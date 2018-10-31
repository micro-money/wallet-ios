//
//  AssetQRView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 23.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import QRCode

class AssetQRView: UIView {

    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.clipsToBounds = true
            backView.layer.cornerRadius = 14
            backView.backgroundColor = UIColor(componentType: .popBackground)
        }
    }
    @IBOutlet weak var centerBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let closeButtonImage = R.image.closeIcon()
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            closeButton.tintColor = UIColor(componentType: .popButtonClose)
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var hashTextField: UITextField! {
        didSet {
            hashTextField.clipsToBounds = true
            hashTextField.layer.cornerRadius = 4
            hashTextField.backgroundColor = UIColor(componentType: .popInputBackground)
            hashTextField.textColor = UIColor(componentType: .navigationText)
        }
    }

    var copiedPopup: CopiedView?

    var hashString: String = "" {
        didSet {
            hashTextField.text = hashString

            if var qrCode = QRCode(hashString) {
                qrCode.color = CIColor(color: UIColor(componentType: .navigationText))
                qrCode.backgroundColor = CIColor(color: UIColor(componentType: .popBackground))

                qrImageView.image = qrCode.image
            }
        }
    }

    @IBAction func adressTouchAction(_ sender: Any) {
        UIPasteboard.general.string = hashTextField.text
        if copiedPopup == nil {
            copiedPopup = R.nib.copiedView.firstView(owner: nil)
            self.addSubview(copiedPopup!)
            copiedPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(hashTextField).offset(-30)
                make.centerX.equalTo(hashTextField)
                make.width.equalTo(136)
                make.height.equalTo(36)
            }
            copiedPopup!.alpha = 0

            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.copiedPopup?.alpha = 1
            }, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.copiedPopup?.alpha = 0
                }) { [weak self] complete in
                    self?.copiedPopup?.removeFromSuperview()
                    self?.copiedPopup = nil
                }
            }
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func editBeginAction(_ sender: Any) {
        centerBackViewConstraint.constant = -(UIScreen.main.bounds.height - backView.bounds.width)*0.25
    }
    
    @IBAction func editEndAction(_ sender: Any) {
        centerBackViewConstraint.constant = 0
    }
}
