//
//  ConfirmPinViewController.swift
//  Wallet
//
//  Created by Oleg Leizer on 15.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit
import LocalAuthentication

class ConfirmPinViewController: BaseViewController, PinCodeTextFieldDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pinView: PinCodeTextField!
    @IBOutlet weak var errorLabel: UILabel!

    var firstPin: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pinView.text = ""
        pinView.becomeFirstResponder()

    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func configureView(isRefresh: Bool) {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.tintColor = Color(.primary)

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        pinView.textColor = UIColor(componentType: .navigationText)
        pinView.placeholderColor = UIColor(componentType: .navigationText)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "setuppin.settings.repeat".localized()

        pinView.becomeFirstResponder()
        errorLabel.isHidden = true
        pinView.delegate = self
        pinView.keyboardType = .numberPad
        pinView.characterLimit = firstPin!.count

        var placeholderText = ""
        for _ in 0..<pinView.characterLimit{
            placeholderText.append("◦")
        }
        pinView.placeholderTextString = placeholderText
        pinView.text = ""
    }

    func applyData(firstPin: String) {
        self.firstPin = firstPin
    }

    // MARK: - PinCodeTextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        textField.text = nil
        errorLabel.isHidden = true

        return true
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        if let pin = textField.text {
            if pin == firstPin {
                nextAction()
            } else {
                errorLabel.isHidden = false
            }
        }
        return true
    }

    @objc func nextAction() {
        guard let stringPin = pinView.text else { return }
        if stringPin != firstPin {
            errorLabel.isHidden = false
            return
        }

        DefaultsManager.shared.isPinLogin = true
        KeychainManager.shared.setPin(value: stringPin)

        if FaceId.isSupported {
            navigateToCreatePasscodeFaceId()
        } else if TouchId.isSupported {
            navigateToCreatePasscodeTouchId()
        } else {
            BaseViewController.resetRootToDashboardController()
        }

    }

}
