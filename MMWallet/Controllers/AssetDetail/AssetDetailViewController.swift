//
//  AssetDetailViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 20.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum DetailSections {
    case header
    case actions
    case history
    case rows
}

class AssetDetailViewController: BaseViewController, Messageable, Loadable {

    //var output: AssetDetailViewOutput!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            if headerView == nil {
                headerView = tableView.tableHeaderView
                //tableView.tableHeaderView = nil
                //tableView.addSubview(headerView)
                //tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
                //tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
                //updateHeaderView()
            }

            //let frame = headerView.bounds

            tableView.register(R.nib.actionsCell)
            tableView.register(R.nib.detailOutcomingCell)
            tableView.register(R.nib.transactionCommentedCell)
            tableView.register(R.nib.historyCell)
            tableView.register(R.nib.assetDetailHeaderTableViewCell)

            //tableView.estimatedRowHeight = 68
            //tableView.rowHeight = UITableViewAutomaticDimension

            tableView.dataSource = self
            tableView.delegate = self

        }
    }

    let sections: [DetailSections] = [.header, .actions, .history, .rows]

    private let kTableHeaderHeight: CGFloat = 229
    var headerView: UIView!

    var assetsId = 0
    var assetModel: AssetDetailModel! {
        didSet {
            configureView(isRefresh: false)
        }
    }

    var isShowUSD = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Color(componentType: .viewBackground)
        modalPresentationCapturesStatusBarAppearance = true

        self.navigationController?.isNavigationBarHidden = true

        loadData()
    }

    func applyData(assetsId: Int) {
        self.assetsId = assetsId
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if DataManager.shared.isNeedReloadAssets {
            loadData()
            DataManager.shared.isNeedReloadAssets = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false)
    }

    override func configureView(isRefresh: Bool) {

        /*
        if let assetModel = assetModel {
            balanceLabel.text = "$ \(assetModel.rate!.USD.cleanValue6)"

            if assetModel.balanceString.isEmpty {
                cryptoBalanceLabel.text =  "\(assetModel.balance.cleanValue6) \(assetModel.currency)"
            } else {
                cryptoBalanceLabel.text = assetModel.balanceString + " \(assetModel.currency)"
            }

            switch assetModel.currency {
            case "ETH":
                currencyIconView.image = R.image.ethereumIcon()
                currencyLabel.text = "ethereum".uppercased()
            case "BTC":
                currencyIconView.image = R.image.bitcoinIcon()
                currencyLabel.text = "bitcoin".uppercased()
            default:
                currencyIconView.image = nil
            }
        }
        */

        tableView?.reloadData()
    }

    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }

    func loadData() {

        DataManager.shared.getAsset(id: assetsId) { [weak self] (assetModel, error) in
            if error == nil {
                self?.assetModel = assetModel
            }
        }
    }

    func showDetailTransaction(transactionId: Int) {

        if let transaction = StorageManager.shared.getTransaction(id: transactionId) {
            let currentNetwork = NetworkType(rawValue: transaction.network)
            guard let url = URL(string: currentNetwork!.getLink(hash: transaction.hashString)) else {
                return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func showQR(hashString: String) {
        let assetQRView = R.nib.assetQRView.firstView(owner: nil)
        UIApplication.shared.keyWindow?.addSubview(assetQRView!)
        assetQRView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        assetQRView!.hashString = hashString
    }
}

extension AssetDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateHeaderView()
    }
}

extension AssetDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .header:
            return 212
        case .actions:
            return 70
        case .history:
            return 48
        case .rows:
            let model = assetModel!.transactionList[indexPath.row]
            if model.descr == "" {
                return 80
            } else {
                return 111
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .rows:
            let model = assetModel!.transactionList[indexPath.row]
            showDetailTransaction(transactionId: model.id)
        default:
            return
        }

    }
}

extension AssetDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .actions:
            return 1
        case .history:
            if assetModel == nil {
                return 0
            }
            return 1
        case .rows:
            if assetModel == nil {
                return 0
            }
            return assetModel.transactionList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.assetDetailHeaderTableViewCell.identifier, for: indexPath) as! AssetDetailHeaderTableViewCell
            if assetModel == nil {
                cell.assetSmallModel = StorageManager.shared.getAsset(id: assetsId)
            }
            cell.assetModel = assetModel
            return cell
        case .actions:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.actionsCell.identifier, for: indexPath) as! ActionsCell
            cell.delegate = self
            return cell
        case .history:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.historyCell.identifier, for: indexPath) as! HistoryCell
            if assetModel != nil {
                cell.curCurrency = assetModel.symbol
            }
            cell.delegate = self
            return cell
        case .rows:
            /*
            let model = assetModel!.transactionList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.detailOutcomingCell.identifier, for: indexPath) as! DetailOutcomingCell
            cell.isShowUSD = isShowUSD
            cell.transactionModel = model
            cell.delegate = self
            return cell*/

            let model = assetModel!.transactionList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.detailOutcomingCell.identifier, for: indexPath) as! DetailOutcomingCell
            cell.isShowUSD = isShowUSD
            cell.transactionModel = model
            cell.delegate = self
            return cell
            /*
            if model.descr.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.detailOutcomingCell.identifier, for: indexPath) as! DetailOutcomingCell
                cell.isShowUSD = isShowUSD
                cell.transactionModel = model
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.transactionCommentedCell.identifier, for: indexPath) as! TransactionCommentedCell
                cell.isShowUSD = isShowUSD
                cell.transactionModel = model
                cell.delegate = self
                return cell
            }*/
            
        }
    }
}

extension AssetDetailViewController: HistoryCellDelegate {
    func historyCellDelegateShowUsd(_ historyCell: HistoryCell) {
        isShowUSD = true
        tableView.reloadData()
    }
    func historyCellDelegateShowCurrency(_ historyCell: HistoryCell) {
        isShowUSD = false
        tableView.reloadData()
    }
}

extension AssetDetailViewController: ActionsCellDelegate {
    func actionsCellShowReceive(_ actionsCell: ActionsCell) {

    }
    func actionsCellShowSend(_ actionsCell: ActionsCell) {
        navigateToSend(assetsId: assetsId)
    }
    func actionsCellShowQR(_ actionsCell: ActionsCell) {
        if let assetModel = assetModel {
                showQR(hashString: assetModel.address)
        }
    }
}

extension AssetDetailViewController: DetailOutcomingCellDelegate {
    func detailOutcomingCellAddContactDirectionFrom(_ detailOutcomingCell: DetailOutcomingCell, fromTransaction transactionModelId: Int?) {

    }
    func detailOutcomingCellAddContactDirectionTo(_ detailOutcomingCell: DetailOutcomingCell, fromTransaction transactionModelId: Int?) {

    }
}

extension AssetDetailViewController: TransactionCommentedCellDelegate {
    func transactionCommentedCellAddContactDirectionFrom(_ transactionCommentedCell: TransactionCommentedCell, fromTransaction transactionModelId: Int?) {

    }
    func transactionCommentedCellAddContactDirectionTo(_ transactionCommentedCell: TransactionCommentedCell, fromTransaction transactionModelId: Int?) {

    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
