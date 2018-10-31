//
//  QRView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 02.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import QRCode

class QRView: UIView {
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.clipsToBounds = true
            backView.layer.cornerRadius = 14
            backView.backgroundColor = UIColor(componentType: .popBackground)
        }
    }
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let closeButtonImage = R.image.closeIcon()
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            closeButton.tintColor = UIColor(componentType: .popButtonClose)
        }
    }
    
    var copiedPopup: CopiedView?
    
    var hashString: String = "" {
        didSet {
            if var qrCode = QRCode(hashString) {
                qrCode.color = CIColor(color: UIColor(componentType: .navigationText))
                qrCode.backgroundColor = CIColor(color: UIColor(componentType: .popBackground))

                qrImageView.image = qrCode.image
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
}
