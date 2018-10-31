//
//  SettingsHeaderTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }

    func configureView() {
        self.backgroundColor = UIColor(componentType: .viewBackground)
        lineView.backgroundColor = UIColor(componentType: .settingsLine)

        nameLabel.textColor = UIColor(componentType: .navigationText)
        emailLabel.textColor = UIColor(componentType: .labelPlaceholder)
    }

    func applyData(name: String, email: String) {
        nameLabel.text = name
        emailLabel.text = email

        configureView()
    }
}
