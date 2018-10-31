//
//  TextTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 11.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        titleLabel.textColor = UIColor(componentType: .labelPlaceholder)
    }

    func applyData(title: String) {
        titleLabel.text = title

        configureView()
    }

}
