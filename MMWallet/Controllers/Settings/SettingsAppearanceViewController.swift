//
//  SettingsAppearanceViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsAppearanceViewController: BaseViewController {

    enum SettingsAppearanceSections {
        case empty
        case dark
        case light
    }

    let sections: [SettingsAppearanceSections] = [.empty, .dark, .light]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.emptyTableViewCell)
            tableView.register(R.nib.settingsTableViewCell)

            tableView.dataSource = self
            tableView.delegate = self

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

extension SettingsAppearanceViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.row] {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            return cell
        case .dark:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.applyData(title: "Dark", dataString: "")
            return cell
        case .light:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.applyData(title: "Light", dataString: "")
            return cell
        }
    }
}

extension SettingsAppearanceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .dark:
            DefaultsManager.shared.isDarkTheme = true
            NotificationCenter.default.post(name: .switchThemeNotificationName, object: nil)
            navigateToBack()
        case .light:
            DefaultsManager.shared.isDarkTheme = false
            NotificationCenter.default.post(name: .switchThemeNotificationName, object: nil)
            navigateToBack()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch sections[indexPath.row] {
        case .empty:
            return 25
        default:
            break
        }
        return 44
    }
}
