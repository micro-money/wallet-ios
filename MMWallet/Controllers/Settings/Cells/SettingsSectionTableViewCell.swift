//
//  SettingsSectionTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 06.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {
        self.backgroundColor = UIColor(componentType: .viewBackground)
    }

    func applyData(title: String) {
        titleLabel.text = title

        configureView()
    }

}
