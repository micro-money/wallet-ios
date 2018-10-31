//
//  SendButtonTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SendButtonTableViewCell: UITableViewCell {

    var delegate: SendButtonTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        self.backgroundColor = UIColor(componentType: .viewBackground)
    }

    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.shadowColor = UIColor.black.cgColor
            backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
            backView.layer.shadowRadius = 2
            backView.layer.shadowOpacity = 0.08
            //        containerView.layer.masksToBounds = false
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
            backView.layer.shadowPath = path.cgPath

            backView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }
    @IBOutlet weak var slidingButton: MMSlidingButton! {
        didSet {
            slidingButton.delegate = self
            slidingButton.buttonColor = UIColor(componentType: .textFieldBackground)
        }
    }

    var isEnabledButton = false {
        didSet {
            slidingButton.isEnabled = isEnabledButton
        }
    }

    func setSuccesIcon() {
        slidingButton?.setSuccesIcon()
    }

    func reset() {
        slidingButton?.reset()
    }
}

extension SendButtonTableViewCell: SlideButtonDelegate {
    func buttonStatus(status:String, sender:MMSlidingButton) {
        if status == "Unlocked" {
            delegate?.sendButtonTableViewCellAction(self)
        }
    }
}

protocol SendButtonTableViewCellDelegate {
    func sendButtonTableViewCellAction(_ sendButtonTableViewCell: SendButtonTableViewCell)
}
