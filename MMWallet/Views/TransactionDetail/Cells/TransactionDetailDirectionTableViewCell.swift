//
//  TransactionDetailDirectionTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 22.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailDirectionTableViewCell: UITableViewCell {

    var delegate: TransactionDetailDirectionTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directionButton: UIButton! {
        didSet {
            directionButton.titleLabel?.lineBreakMode = .byWordWrapping
            directionButton.titleLabel?.numberOfLines = 2
        }
    }

    var hashString = ""

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
        hashString = dataString
        //directionButton.setTitle(dataString, for: .normal)

        let attachment = NSTextAttachment()
        attachment.image = R.image.iconLaunch()
        let attachmentString = NSAttributedString(attachment: attachment)
        let strLabelText = NSMutableAttributedString(string: dataString + " ")
        strLabelText.append(attachmentString)
        directionButton.setAttributedTitle(strLabelText, for: .normal)

    }
    @IBAction func selectHashAction(_ sender: Any) {
        delegate?.transactionDetailDirectionTableViewCell(self, didSelect: hashString)
    }
    
    func getHeight() -> CGFloat {
        return 82
    }
    
}

protocol TransactionDetailDirectionTableViewCellDelegate {
    func transactionDetailDirectionTableViewCell(_ transactionDetailDirectionTableViewCell: TransactionDetailDirectionTableViewCell, didSelect hashString: String?)
}
