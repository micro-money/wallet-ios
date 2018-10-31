//
//  DashboardViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import SnapKit

enum DashboardSections {
    case crypto
    case fiat
    case token
}

class DashboardViewController: BaseViewController, Messageable, Loadable {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerSmallView: UIView!
    @IBOutlet weak var backViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerBalanceLabel: UILabel!
    private let kTableHeaderHeight: CGFloat = 109
    private let kHeaderHeight: CGFloat = 90
    private let kHeaderDeltaHeight: CGFloat = 25
    var headerView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.dashboardCryptoTableViewCell)
            tableView.register(R.nib.dashboardFiatTableViewCell)
            tableView.register(R.nib.dashboardSectionTableViewCell)
            tableView.register(R.nib.emptyTableViewCell)
            tableView.separatorColor = .clear
            tableView.estimatedRowHeight = 65
            tableView.rowHeight = UITableView.automaticDimension

            refreshControl.tintColor = UIColor.white
            tableView.addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(refreshList), for: UIControl.Event.valueChanged)
        }
    }
    let sections: [DashboardSections] = [.crypto, .token, .fiat]
    private var assets: [AssetModel] = [] {
        didSet {
            assetsCrypto = StorageManager.shared.getAssets(type: .crypto)
            assetsToken = StorageManager.shared.getAssets(type: .token)
            assetsFiat = StorageManager.shared.getAssets(type: .fiat)
            //loadTokensInfo()
            self.tableView.reloadData()
        }
    }

    private var assetsCrypto: [AssetModel]?
    private var assetsToken: [AssetModel]?
    private var assetsFiat: [AssetModel]?

    let refreshControl = UIRefreshControl()

    private var wallet: WalletModel? {
        didSet {
            self.updateWallet()
        }
    }

    var currencyChartView: CurrencyChartView?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
        loadData()

        self.tabBarController?.tabBar.unselectedItemTintColor = Color(componentType: .tabbarUnselected)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            return .lightContent
        }
        return .default
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        refreshControl.frame = CGRect(x: refreshControl.bounds.origin.x,
                y: refreshControl.frame.origin.y - 80,
                width: refreshControl.bounds.size.width,
                height: refreshControl.bounds.size.height);
        refreshControl.superview?.sendSubviewToBack(refreshControl) // for fix overlap tableview

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if DataManager.shared.isNeedReloadWallet {
            loadData()
            DataManager.shared.isNeedReloadWallet = false
        }
    }

    override func configureView(isRefresh: Bool) {

        if !isRefresh {
            tabBarItem.title = nil

            if tableView.tableHeaderView != nil {
                headerView = tableView.tableHeaderView
                tableView.tableHeaderView = nil
                headerView.backgroundColor = .clear
                tableView.addSubview(headerView)
                tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
                tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
            }

            updateHeaderView()

            addCurrencyChart()
        }

        backView.backgroundColor = UIColor(componentType: .viewBackground)

        if isRefresh {
            tableView.reloadData()
        }
    }

    func loadData(isNeedFromCache: Bool = true) {

        DataManager.shared.getWallet(isNeedFromCache: isNeedFromCache) { [weak self] (walletModel, error) in
            self?.refreshControl.endRefreshing()
            if walletModel != nil {
                self?.wallet = walletModel
                if let assets = StorageManager.shared.getAssets() {
                    self?.assets = assets
                } else {
                    self?.assets = []
                }
            }
        }

        if isNeedFromCache {
            DataManager.shared.getCurrencyRates { [weak self] ( _, error) in
                self?.currencyChartView?.applyData(currency: nil)
            }

            DataManager.shared.testEmailConfirmation()
            DataManager.shared.testPasswordConfirmation()
        }
    }

    func loadTokensInfo() {

        for token in assetsToken! {
            DataManager.shared.findTokenByAddress(address: token.address) { (tokenInfoModels, error) in
                if error == nil {

                }
            }
        }
    }
 
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    
    @IBAction func logoutButtonTouched(_ sender: Any) {
        //output.logoutAction()
    }
    
    private func updateWallet() {
        guard let wallet = self.wallet else { return }
        
        self.headerBalanceLabel.text = "$ \(wallet.balance.cleanValue)"
    }

    private func addCurrencyChart() {
        currencyChartView = R.nib.currencyChartView.firstView(owner: nil)
        headerView.addSubview(currencyChartView!)
        currencyChartView!.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(78)
        }
    }

    @objc func refreshList() {
        loadData(isNeedFromCache: false)
    }

    func deleteAction(indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let index = indexPath.row - 1

        switch sections[indexPath.section] {
        case .crypto:
            let model = self.assetsCrypto![index/2]
            deleteQuestion(assetId: model.id)
        case .token:
            let model = self.assetsToken![index/2]
            deleteQuestion(assetId: model.id)
        case .fiat:
            break
        }

    }

    func deleteAssetAction(assetId: Int) {
        self.showLoader()
        DataManager.shared.deleteAsset(assetId: assetId) { [weak self] (errorString, error) in
            if error == nil {
                self?.hideLoaderSuccess()
                self?.assetsCrypto = StorageManager.shared.getAssets(type: .crypto)
                self?.assetsToken = StorageManager.shared.getAssets(type: .token)
                self?.assetsFiat = StorageManager.shared.getAssets(type: .fiat)
                self?.tableView.reloadData()
            } else {
                self?.hideLoaderFailure()
            }
        }
    }

    func deleteQuestion(assetId: Int) {
        let alert = UIAlertController(title: "common.delete-asset-alert-title".localized(),
                message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "common.delete-asset-destructive".localized(),
                style: .destructive) { [weak self] _ in
            self?.deleteAssetAction(assetId: assetId)
        })
        alert.addAction(UIAlertAction(title: "common.alert-cancel".localized(),
                style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        updateHeaderView()

        let offset = kTableHeaderHeight + scrollView.contentOffset.y
        if offset < kHeaderDeltaHeight {
            headerHeightConstraint.constant = kHeaderHeight - offset
            headerSmallView.layoutIfNeeded()
        } else if offset >= kHeaderDeltaHeight {
            headerHeightConstraint.constant = kHeaderHeight - kHeaderDeltaHeight
            headerSmallView.layoutIfNeeded()
        }

        if offset < 0 {
            headerHeightConstraint.constant = kHeaderHeight
            backViewHeightConstraint.constant = kTableHeaderHeight - offset
        } else {
            backViewHeightConstraint.constant = kTableHeaderHeight
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .crypto:
            if assetsCrypto == nil || assetsCrypto!.count == 0{
                return 1
            }
            return assetsCrypto!.count*2 + 1
        case .fiat:
            //return 2
            if assetsFiat == nil || assetsFiat!.count == 0{
                return 0
            }
            return assetsFiat!.count + 1
        case .token:
            if assetsToken == nil || assetsToken!.count == 0{
                return 1
            }
            return assetsToken!.count*2 + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row - 1

        switch sections[indexPath.section] {
        case .crypto:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardSectionTableViewCell.identifier, for: indexPath) as! DashboardSectionTableViewCell
                cell.titleLabel.text = "My cryptocurrencies"
                cell.currentSection = .crypto
                cell.delegate = self
                return cell
            } else {
                if index%2 == 0 {
                    let model = self.assetsCrypto![index/2]
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardCryptoTableViewCell.identifier, for: indexPath) as! DashboardCryptoTableViewCell
                    cell.assetModel = model
                    cell.configureView()
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
                cell.configureView()
                //cell.backgroundColor = .clear
                return cell
            }
        case .fiat:
            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardSectionTableViewCell.identifier, for: indexPath) as! DashboardSectionTableViewCell
                cell.titleLabel.text = "My currencies"
                cell.currentSection = .fiat
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardFiatTableViewCell.identifier, for: indexPath) as! DashboardFiatTableViewCell
                cell.countLabel.text = "000.00 USD"
                cell.currencyLabel.text = "US Dollar"
                cell.logoImageView.image = R.image.usdIcon()
                cell.configureView()
                return cell
            }
        case .token:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardSectionTableViewCell.identifier, for: indexPath) as! DashboardSectionTableViewCell
                cell.titleLabel.text = "My tokens"
                cell.currentSection = .token
                cell.delegate = self
                return cell
            } else {
                if index%2 == 0 {
                    let model = self.assetsToken![index/2]
                    //let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardCryptoTableViewCell.identifier, for: indexPath) as! DashboardCryptoTableViewCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardFiatTableViewCell.identifier, for: indexPath) as! DashboardFiatTableViewCell
                    cell.assetModel = model
                    cell.configureView()
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
                //cell.backgroundColor = .clear
                cell.configureView()
                return cell
            }
            
        }
    }
}
extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row - 1
        switch sections[indexPath.section] {
        case .crypto:
            if assetsCrypto!.count > 0 {
                if assetsCrypto![0].isInvalidated {
                    assetsCrypto = StorageManager.shared.getAssets(type: .crypto)
                }
                if indexPath.row > 0 {
                    let model = assetsCrypto![index/2]
                    if model.isNetworkAvailable {
                        navigateToAssetsDetail(assetsId: model.id)
                    }
                }
                
            }
        case .token:
            if assetsToken!.count > 0 {
                if assetsToken![0].isInvalidated {
                    assetsToken = StorageManager.shared.getAssets(type: .token)
                }
                if indexPath.row > 0 {
                    let model = assetsToken![index/2]
                    if model.isNetworkAvailable {
                        navigateToAssetsDetail(assetsId: model.id)
                    }
                }
            }
        default:
            return
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                return 53
            }
            return 43
        } else {
            if sections[indexPath.section] == .fiat {
                return 75
            }

            let index = indexPath.row - 1
            if index%2 == 1 {
                return 10
            }
            return 65
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        if indexPath.row == 0 {
            return []
        }

        if sections[indexPath.section] == .fiat ||  sections[indexPath.section] == .crypto{
            return []
        }

        let index = indexPath.row - 1
        if index%2 == 1 {
            return []
        }

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteAction(indexPath: indexPath)
        }

        return [delete]

    }
}

extension DashboardViewController: DashboardSectionTableViewCellDelegate {
    func dashboardSectionTableViewCellAction(_ dashboardSectionTableViewCell: DashboardSectionTableViewCell) {
        self.tabBarController?.selectedIndex = BaseTabBarSection.add.rawValue
    }
}
