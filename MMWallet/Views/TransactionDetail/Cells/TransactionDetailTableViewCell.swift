//
//  TransactionDetailTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 22.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {

        titleLabel.textColor = UIColor(componentType: .popText)
        dataLabel.textColor = UIColor(componentType: .labelPlaceholder)
    }

    func applyData(titleString: String, dataString: String) {
        titleLabel.text = titleString
        dataLabel.text = dataString
    }

    func getHeight() -> CGFloat {
        dataLabel.sizeToFit()
        return 10 + titleLabel.bounds.height + 6 + dataLabel.bounds.height + 10
    }
}
