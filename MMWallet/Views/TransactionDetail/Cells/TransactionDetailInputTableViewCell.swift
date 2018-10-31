//
//  TransactionDetailInputTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 22.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailInputTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var inputTextField: TransactionDetailInputTextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {

        inputTextField.backgroundColor = UIColor(componentType: .textFieldBackground)
        inputTextField.textColor = UIColor(componentType: .textFieldText)
        //inputTextField.isUserInteractionEnabled = false

        titleLabel.textColor = UIColor(componentType: .popText)
    }

    override func layoutSubviews() {
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.8)
        backView.layer.shadowRadius = 2
        backView.layer.shadowOpacity = 0.05
        //        containerView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
        backView.layer.shadowPath = path.cgPath
    }

    func applyData(titleString: String, dataString: String) {
        titleLabel.text = titleString
        inputTextField.text = dataString
    }

    func getHeight() -> CGFloat {
        return 86
    }
}
