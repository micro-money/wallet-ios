//
//  SettingsViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    enum SettingsSections {
        case header
        case sectionPrivacy
        case useSecurityID
        case changePasscode
        case exportKeys
        case createBackup
        case sectionApp
        case appearance
        case sectionLogout
        case logout
    }

    var sections: [SettingsSections] = [.header, .sectionPrivacy, .useSecurityID, .changePasscode, .exportKeys, .createBackup, .sectionApp, .appearance, .sectionLogout, .logout]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.settingsHeaderTableViewCell)
            tableView.register(R.nib.settingsSectionTableViewCell)
            tableView.register(R.nib.settingsSwitcherTableViewCell)
            tableView.register(R.nib.settingsTableViewCell)
            tableView.register(R.nib.settingsLogoutTableViewCell)
            
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    var isSecurityIDEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkSecurityID()

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        self.navigationController?.isNavigationBarHidden = true
    }

    func checkSecurityID() {
        if !FaceId.isSupported && !TouchId.isSupported {
            isSecurityIDEnabled = false
        } else {
            isSecurityIDEnabled = true
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            return .lightContent
        }
        return .default
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func logoutQuestion() {
        let alert = UIAlertController(title: "common.logout-alert-title".localized(),
                message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "common.logout-alert-destructive".localized(),
                style: .destructive) { [weak self] _ in
            self?.logoutAction()
        })
        alert.addAction(UIAlertAction(title: "common.alert-cancel".localized(),
                style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func logoutAction() {
        KeychainManager.shared.setPin(value: "")
        DefaultsManager.shared.isBioLogin = false
        DefaultsManager.shared.isPinLogin = false
        BaseViewController.resetToRootController()
    }
}

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSecurityIDEnabled {
            sections.removeObject(object: .useSecurityID)
        }
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.row] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsHeaderTableViewCell.identifier, for: indexPath) as! SettingsHeaderTableViewCell
            cell.selectionStyle = .none
            if let user = StorageManager.shared.getUsers()?.first {
                cell.applyData(name: user.displayName, email: user.email)
            }
            return cell
        case .sectionPrivacy:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsSectionTableViewCell.identifier, for: indexPath) as! SettingsSectionTableViewCell
            cell.applyData(title: "settings.privacy-settings".localized())
            return cell
        case .sectionApp:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsSectionTableViewCell.identifier, for: indexPath) as! SettingsSectionTableViewCell
            cell.applyData(title: "settings.app-settings".localized())
            return cell
        case .sectionLogout:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsSectionTableViewCell.identifier, for: indexPath) as! SettingsSectionTableViewCell
            cell.applyData(title: "settings.logout".localized())
            return cell
        case .useSecurityID:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsSwitcherTableViewCell.identifier, for: indexPath) as! SettingsSwitcherTableViewCell
            if FaceId.isSupported {
                if DefaultsManager.shared.isBioLogin == nil {
                    cell.applyData(title: "settings.use-faceID".localized(), isSelected: false)
                } else {
                    cell.applyData(title: "settings.use-faceID".localized(), isSelected: true)
                }
            } else if TouchId.isSupported {
                if DefaultsManager.shared.isBioLogin == nil {
                    cell.applyData(title: "settings.use-touchID".localized(), isSelected: false)
                } else {
                    cell.applyData(title: "settings.use-touchID".localized(), isSelected: true)
                }
            } else {
                cell.applyData(title: "----", isSelected: false)
            }
            cell.selectionStyle = .none
            return cell
        case .changePasscode:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.applyData(title: "settings.change-passcode".localized(), dataString: "")
            if let pin = KeychainManager.shared.pin {
                if pin.isEmpty {
                    cell.isEnabledCell = false
                } else {
                    cell.isEnabledCell = true
                }
            } else {
                cell.isEnabledCell = false
            }
            return cell
        case .exportKeys:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.applyData(title: "settings.exportprivatekeys".localized(), dataString: "")
            return cell
        case .createBackup:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.applyData(title: "settings.create-backup".localized(), dataString: "")
            cell.isEnabledCell = false
            return cell
        case .appearance:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            if DefaultsManager.shared.isDarkTheme! {
                cell.applyData(title: "settings.appearance".localized(), dataString: "settings.dark".localized())
            } else {
                cell.applyData(title: "settings.appearance".localized(), dataString: "settings.light".localized())
            }
            return cell
        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsLogoutTableViewCell.identifier, for: indexPath) as! SettingsLogoutTableViewCell
            cell.applyData(title: "settings.logout".localized())
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .exportKeys:
            navigateToSettingsExportSelect()
        case .appearance:
            navigateToSettingsAppearance()
        case .logout:
            logoutQuestion()
        case .changePasscode:
            navigateToSettingsPasscode()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch sections[indexPath.row] {
            case .header:
                return 77
            case .sectionPrivacy:
                return 46
            case .sectionApp:
                return 46
            case .sectionLogout:
                return 46
        default:
            break
        }
        return 44
    }
}
