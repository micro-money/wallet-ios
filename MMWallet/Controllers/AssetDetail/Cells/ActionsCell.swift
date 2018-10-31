//
//  ActionsCell.swift
//  MMWallet
//
//  Created by Oleg Leizer on 29.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit

class ActionsCell: UITableViewCell {

    var delegate: ActionsCellDelegate?

    @IBOutlet weak var receiveButton: UIButton! {
        didSet {
            if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                receiveButton.setImage(R.image.receiveWhiteIcon(), for: .normal)
            } else {
                receiveButton.setImage(R.image.receiveIcon(), for: .normal)
            }
            receiveButton.setTitleColor(UIColor(componentType: .navigationText), for: .normal)
        }
    }
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var qrCodeButton: UIButton! {
        didSet {
            let qrButtonImage = R.image.qrIcon()
            qrCodeButton.setImage(qrButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            qrCodeButton.tintColor = UIColor(componentType: .navigationText)
            qrCodeButton.setTitleColor(UIColor(componentType: .navigationText), for: .normal)
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                sendButton.setImage(R.image.sendWhiteIcon(), for: .normal)
            } else {
                sendButton.setImage(R.image.sendIcon(), for: .normal)
            }
            sendButton.setTitleColor(UIColor(componentType: .navigationText), for: .normal)
        }
    }

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        backView.layer.shadowRadius = 2
        backView.layer.shadowOpacity = 0.05
        backView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
        backView.layer.shadowPath = path.cgPath

        self.clipsToBounds = false

        backView.backgroundColor = UIColor(componentType: .subNavigationBackground)
        lineView.backgroundColor = UIColor(componentType: .textFieldNormalLine)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func receiveButtonTouched(_ sender: Any) {
        delegate?.actionsCellShowReceive(self)
    }
    @IBAction func qrCodeButtonTouched(_ sender: Any) {
        delegate?.actionsCellShowQR(self)
    }
    @IBAction func sendButtonTouched(_ sender: Any) {
        delegate?.actionsCellShowSend(self)
    }
}

protocol ActionsCellDelegate {
    func actionsCellShowReceive(_ actionsCell: ActionsCell)
    func actionsCellShowSend(_ actionsCell: ActionsCell)
    func actionsCellShowQR(_ actionsCell: ActionsCell)
}
