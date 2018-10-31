//
//  VerifyEmailView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 02.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class VerifyEmailView: UIView, LoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    
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

    func configureView(userId: Int) {

        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        okButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)

        okButton.backgroundColor = Color(componentType: .buttonFill)
        okButton.layer.cornerRadius = 5

        titleLabel.backgroundColor = UIColor(componentType: .popBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "verifyemail.title".localized()

        messageLabel.backgroundColor = UIColor(componentType: .popBackground)
        messageLabel.textColor = UIColor(componentType: .navigationText)

        if let user = StorageManager.shared.getUser(id: userId) {
            messageLabel.text = "verifyemail.to".localized() + user.email + "verifyemail.text".localized()
        }

    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func resendAction(_ sender: Any) {
        self.showLoader()
        DataManager.shared.resendEmailToVerify() { [weak self] (userModel, error) in
            if error == nil {
                self?.hideLoaderSuccess() { [weak self] in
                    self?.removeFromSuperview()
                }
            } else {
                self?.hideLoaderFailure() { [weak self] in
                    self?.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func okAction(_ sender: Any) {
        removeFromSuperview()
    }
}
