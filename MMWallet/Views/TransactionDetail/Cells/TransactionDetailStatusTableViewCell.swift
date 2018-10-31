//
//  TransactionDetailStatusTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 22.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusIconView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {

        titleLabel.textColor = UIColor(componentType: .popText)
    }

    func applyData(titleString: String, dataString: String) {
        titleLabel.text = titleString

        statusLabel.text = dataString.capitalizingFirstLetter()

        switch dataString {
        case "success":
            statusIconView.image = R.image.statusDone()
            statusLabel.textColor = Color(componentType: .labelStatusDone)
        case "cancelled":
            statusIconView.image = R.image.statusCancelled()
            statusLabel.textColor = Color(componentType: .labelStatusCancelled)
        case "pending":
            statusIconView.image = R.image.statusPending()
            statusLabel.textColor = Color(componentType: .labelStatusPending)
        default:
            statusIconView.image = nil
        }
    }

    func getHeight() -> CGFloat {
        return 64
    }
}
