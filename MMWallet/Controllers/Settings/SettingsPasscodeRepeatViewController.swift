//
//  SettingsPasscodeRepeatViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 10.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsPasscodeRepeatViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pinView: PinCodeTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var firstPin = ""

    var pinCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    func applyData(firstPin: String) {
        self.firstPin = firstPin
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pinView.text = ""
        pinCode = ""
        pinView.becomeFirstResponder()
        errorLabel.isHidden = true

    }
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func configureView(isRefresh: Bool) {

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        pinView.textColor = UIColor(componentType: .navigationText)
        pinView.placeholderColor = UIColor(componentType: .navigationText)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "settings.passcodenethernew".localized()

        pinView.becomeFirstResponder()
        pinView.delegate = self
        pinView.keyboardType = .numberPad
        pinView.characterLimit = firstPin.count

        var placeholderText = ""
        for _ in 0..<pinView.characterLimit{
            placeholderText.append("◦")
        }
        pinView.placeholderTextString = placeholderText
        pinView.text = ""
    }

}

extension SettingsPasscodeRepeatViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        textField.text = nil
        return true
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        if let pin = textField.text {
            self.pinCode = pin

            if pinCode == firstPin {
                KeychainManager.shared.setPin(value: pinCode)
                navigateBackToSettings()
            } else {
                errorLabel.isHidden = false
                pinView.text = ""
                pinCode = ""
                return false
            }
        }
        return true
    }
}
