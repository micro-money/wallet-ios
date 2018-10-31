//
//  SettingsAssetsViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsAssetsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.dashboardCryptoTableViewCell)
            tableView.register(R.nib.dashboardFiatTableViewCell)
            tableView.register(R.nib.dashboardSectionTableViewCell)

            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    let sections: [DashboardSections] = [.crypto, .token, .fiat]
    private var assets: [AssetModel] = [] {
        didSet {
            if currencyString != nil {
                assetsCrypto = StorageManager.shared.getAssets(currency: currencyString!)
                assetsToken = []
                assetsFiat = []
            } else {
                assetsCrypto = StorageManager.shared.getAssets(type: .crypto)
                assetsToken = StorageManager.shared.getAssets(type: .token)
                assetsFiat = StorageManager.shared.getAssets(type: .fiat)
            }

            self.tableView.reloadData()
        }
    }

    private var assetsCrypto: [AssetModel]?
    private var assetsToken: [AssetModel]?
    private var assetsFiat: [AssetModel]?

    var currencyString: String?
    var exportType: ExportType = .privateKey

    func applyData(currency: String?, exportType: ExportType) {
        currencyString = currency
        self.exportType = exportType
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
        loadData()
    }

    override func configureView(isRefresh: Bool) {

        self.view.backgroundColor = UIColor(componentType: .viewBackground)

    }

    func loadData() {
        if currencyString != nil {
            assets = StorageManager.shared.getAssets(currency: currencyString!)!
        } else {
            assets = StorageManager.shared.getAssets()!
        }
    }
}

extension SettingsAssetsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .crypto:
            if assetsCrypto == nil || assetsCrypto!.count == 0{
                return 1
            }
            return assetsCrypto!.count + 1
        case .fiat:
            //return 2
            if assetsFiat == nil || assetsFiat!.count == 0{
                return 0
            }
            return assetsFiat!.count + 1
        case .token:
            if assetsToken == nil || assetsToken!.count == 0{
                return 0
            }
            return assetsToken!.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .crypto:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardSectionTableViewCell.identifier, for: indexPath) as! DashboardSectionTableViewCell
                cell.titleLabel.text = "My cryptocurrencies"
                cell.currentSection = .crypto
                cell.iconImageView.isHidden = true
                cell.configureView()
                return cell
            } else {
                let model = self.assetsCrypto![indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardCryptoTableViewCell.identifier, for: indexPath) as! DashboardCryptoTableViewCell
                cell.assetModel = model
                cell.configureView()
                return cell
            }
        case .fiat:
            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardSectionTableViewCell.identifier, for: indexPath) as! DashboardSectionTableViewCell
                cell.titleLabel.text = "My currencies"
                cell.currentSection = .fiat
                cell.iconImageView.isHidden = true
                cell.configureView()
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
                cell.iconImageView.isHidden = true
                cell.configureView()
                return cell
            } else {
                let model = self.assetsToken![indexPath.row - 1]
                //let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardCryptoTableViewCell.identifier, for: indexPath) as! DashboardCryptoTableViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.dashboardFiatTableViewCell.identifier, for: indexPath) as! DashboardFiatTableViewCell
                cell.assetModel = model
                cell.configureView()
                return cell
            }

        }
    }
}
extension SettingsAssetsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .crypto:
            if assetsCrypto!.count > 0 {
                if indexPath.row > 0 {
                    let model = assetsCrypto![indexPath.row - 1]
                    if model.isInvalidated {
                        loadData()
                        return
                    }
                    switch exportType {
                        case .privateKey:
                            navigateToSettingsExportKeys(assetId: model.id)
                        case .keystore:
                            navigateToSettingsExportKeystore(assetId: model.id)
                    }
                }

            }
        case .token:
            if assetsToken!.count > 0 {
                if indexPath.row > 0 {
                    let model = assetsToken![indexPath.row - 1]
                    if model.isInvalidated {
                        loadData()
                        return
                    }
                    switch exportType {
                    case .privateKey:
                        navigateToSettingsExportKeys(assetId: model.id)
                    case .keystore:
                        navigateToSettingsExportKeystore(assetId: model.id)
                    }
                }

            }
        default:
            return
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 43
        } else {
            return 75
        }
    }
}
