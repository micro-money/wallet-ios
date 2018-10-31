//
//  SettingsExportKeyButtonTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsExportKeyButtonTableViewCell: UITableViewCell {

    var delegate: SettingsExportKeyButtonTableViewCellDelegate?

    var curSection: SettingsExportKeySections = .none

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        self.backgroundColor = UIColor(componentType: .viewBackground)
    }

    @IBOutlet weak var newButton: UIButton! {
        didSet {
            newButton.layer.cornerRadius = 5
        }
    }

    var isEnabledButton = false {
        didSet {
            newButton.isEnabled = isEnabledButton
        }
    }

    func applyData(title: String, isWhite: Bool = false) {
        newButton.isEnabled = true

        if isWhite {
            newButton.setTitle(title.localized().uppercased(), for: .normal)
            newButton.setTitleColor(Color(componentType: .navigationText), for: .normal)
            newButton.setTitleColor(Color(componentType: .labelPlaceholder), for: .disabled)
            newButton.backgroundColor = UIColor.clear

            if DefaultsManager.shared.isDarkTheme != nil && !DefaultsManager.shared.isDarkTheme! {
                newButton.backgroundColor = UIColor.white
            }

            newButton.layer.borderColor = Color(componentType: .navigationText).cgColor
            newButton.layer.borderWidth = 1
        } else {
            newButton.setTitle(title.localized().uppercased(), for: .normal)
            newButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
            newButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)
            newButton.backgroundColor = Color(componentType: .buttonFill)
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        delegate?.settingsExportKeyButtonTableViewCellAction(self)
    }
}

protocol SettingsExportKeyButtonTableViewCellDelegate {
    func settingsExportKeyButtonTableViewCellAction(_ settingsExportKeyButtonTableViewCell: SettingsExportKeyButtonTableViewCell)
}



