//
//  SettingsLogoutTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsLogoutTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineTopView: UIView!
    @IBOutlet weak var lineButtomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {
        lineTopView.backgroundColor = UIColor(componentType: .settingsLine)
        lineButtomView.backgroundColor = UIColor(componentType: .settingsLine)
        titleLabel.textColor = UIColor(componentType: .buttonLogout)

        self.backgroundColor = UIColor(componentType: .subNavigationBackground)
    }

    func applyData(title: String) {
        titleLabel.text = title

        configureView()
    }

}
