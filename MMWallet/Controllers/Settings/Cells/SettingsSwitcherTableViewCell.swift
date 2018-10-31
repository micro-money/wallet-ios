//
//  SettingsSwitcherTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsSwitcherTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }

    func configureView() {
        lineView.backgroundColor = UIColor(componentType: .settingsLine)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        self.backgroundColor = UIColor(componentType: .subNavigationBackground)
    }

    func applyData(title: String, isSelected: Bool) {
        titleLabel.text = title
        switchView.setOn(isSelected, animated: false)

        configureView()
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        if switchView.isOn {
            DefaultsManager.shared.isBioLogin = true
        } else {
            DefaultsManager.shared.isBioLogin = nil
        }
    }
}
