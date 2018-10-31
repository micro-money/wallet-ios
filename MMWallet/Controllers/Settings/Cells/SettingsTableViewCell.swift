//
//  SettingsTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {
        lineView.backgroundColor = UIColor(componentType: .settingsLine)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        self.backgroundColor = UIColor(componentType: .subNavigationBackground)

        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(componentType: .buttonNewAssetsNext)
    }

    var isEnabledCell = true {
        didSet{
            if isEnabledCell {
                self.backgroundColor = UIColor(componentType: .subNavigationBackground)
            } else {
                self.backgroundColor = UIColor(componentType: .viewBackground)
            }
        }
    }

    func applyData(title: String, dataString: String) {
        titleLabel.text = title
        dataLabel.text = dataString

        configureView()
    }
}
