//
//  PasswordView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 25/10/2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class PasswordView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var centerBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var textField: HashTextField! {
        didSet {
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 4
            textField.backgroundColor = UIColor(componentType: .popInputBackground)
            textField.textColor = UIColor(componentType: .navigationText)
        }
    }
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.clipsToBounds = true
            backView.layer.cornerRadius = 14
            backView.backgroundColor = UIColor(componentType: .popBackground)
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let closeButtonImage = R.image.closeIcon()
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            closeButton.tintColor = UIColor(componentType: .popButtonClose)
        }
    }

    var copiedPopup: CopiedView?
    
    func configureView(password: String) {
        
        okButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        okButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)
        
        okButton.backgroundColor = Color(componentType: .buttonFill)
        okButton.layer.cornerRadius = 5

        textField.text = password

        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "password.title".localized()

        subtitleLabel.textColor = UIColor(componentType: .navigationText)
        subtitleLabel.text = "password.subtitle".localized()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func okAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func touchDownTextField(_ sender: Any) {
        UIPasteboard.general.string = textField.text
        if copiedPopup == nil {
            copiedPopup = R.nib.copiedView.firstView(owner: nil)
            copiedPopup?.textLabel.text = "password.popup".localized()
            self.addSubview(copiedPopup!)
            copiedPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(textField).offset(-30)
                make.centerX.equalTo(textField)
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

    @IBAction func editBeginAction(_ sender: Any) {
        centerBackViewConstraint.constant = -(UIScreen.main.bounds.height - backView.bounds.width)*0.25
    }
    
    @IBAction func editEndAction(_ sender: Any) {
        centerBackViewConstraint.constant = 0
    }
}
