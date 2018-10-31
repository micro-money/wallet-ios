//
//  SettingsExportSelectWarningTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsExportSelectWarningTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(componentType: .navigationText)

        titleLabel.textColor = UIColor(componentType: .navigationText)
        messageLabel.textColor = UIColor(componentType: .navigationText)
    }

}
