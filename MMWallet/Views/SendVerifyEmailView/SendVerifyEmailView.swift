//
//  SendVerifyEmailView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 03.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SendVerifyEmailView: UIView, LoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mailTextField: ClearTextField!
    
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

        sendButton.setTitle("verifyemail.send".localized().uppercased(), for: .normal)
        sendButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        sendButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)

        sendButton.backgroundColor = Color(componentType: .buttonFill)
        sendButton.layer.cornerRadius = 5
        
        titleLabel.backgroundColor = UIColor(componentType: .popBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "verifyemail.title".localized()

        mailTextField.delegate = self
        mailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sendButton.isEnabled = false
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if let email = mailTextField.text {
            if !email.isEmpty {
                self.showLoader()
                DataManager.shared.sendEmailToVerify(email: email) { [weak self] (userModel, error) in
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
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        removeFromSuperview()
    }
}

extension SendVerifyEmailView: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {

        } else {
            sendAction(self)
        }

        return true
    }
}
