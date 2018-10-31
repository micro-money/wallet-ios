//
//  SettingsExportSelectViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit


class SettingsExportSelectViewController: BaseViewController {

    enum SettingsExportSelectSections {
        case warning
        case keystore
        case privatekey
        case none
    }

    let sections: [SettingsExportSelectSections] = [.warning, .privatekey]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.settingsExportSelectTableViewCell)
            tableView.register(R.nib.settingsExportSelectWarningTableViewCell)

            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension SettingsExportSelectViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.row] {
        case .warning:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportSelectWarningTableViewCell.identifier, for: indexPath) as! SettingsExportSelectWarningTableViewCell
            cell.configureView()
            return cell
        case .keystore:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportSelectTableViewCell.identifier, for: indexPath) as! SettingsExportSelectTableViewCell
            cell.applyData(title: "settings.exportkeystore".localized())
            cell.isEnabledCell = false
            return cell
        case .privatekey:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportSelectTableViewCell.identifier, for: indexPath) as! SettingsExportSelectTableViewCell
            cell.applyData(title: "settings.exportprivatekeys".localized())
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
}

extension SettingsExportSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .keystore:
            //navigateToSettingsAssets(currency: "ETH", exportType: .keystore)
            break
        case .privatekey:
            navigateToSettingsAssets(currency: nil, exportType: .privateKey)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch sections[indexPath.row] {
        case .warning:
            return 251
        default:
            break
        }
        return 75
    }
}
