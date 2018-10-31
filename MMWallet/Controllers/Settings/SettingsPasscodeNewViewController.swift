//
//  SettingsPasscodeNewViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 10.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsPasscodeNewViewController: BaseViewController {

    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pinView: PinCodeTextField!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!

    var pinLength: Int = 4 {
        didSet {
            updatePinField()
        }
    }
    let titles = ["setuppin.settings.sixdigit".localized(), "setuppin.settings.fourdigit".localized()]
    var pinType: SettingsAccessor.PinType = .fourNumber {
        didSet {
            SettingsAccessor.shared.pinType = self.pinType
            self.updatePinField()
        }
    }
    var pinCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var placeholderText = ""
        for _ in 0..<pinView.characterLimit{
            placeholderText.append("◦")
        }
        pinView.placeholderTextString = placeholderText
        pinView.text = ""
        pinCode = ""
        pinView.becomeFirstResponder()
        
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

        pinView.delegate = self
        pinView.keyboardType = .numberPad
        if let pin = KeychainManager.shared.pin {
            pinView.characterLimit = pin.count

            var placeholderText = ""
            for _ in 0..<pinView.characterLimit{
                placeholderText.append("◦")
            }
            pinView.placeholderTextString = placeholderText
        }
        pinView.text = ""
    }

    @IBAction func settingAction(_ sender: Any) {

        let alertController = UIAlertController(title: "setuppin.settings.title".localized() , message: nil, preferredStyle: .actionSheet)
        for title in titles {
            let buttonAction = UIAlertAction(title: title, style: .default) { action in
                guard let index = alertController.actions.index(of: action) else { return }
                switch index {
                case 0:
                    print("setuppin.settings.sixdigit".localized())
                    self.pinLength = 6
                    self.pinType = .sixNumber
                case 1:
                    print("setuppin.settings.fourdigit".localized())
                    self.pinLength = 4

                    self.pinType = .fourNumber
                default:
                    print("empty")
                }
            }
            alertController.addAction(buttonAction)
        }
        let cancelAction = UIAlertAction(title: "common.actions.cancel".localized(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    private func updatePinField() {

        self.pinView.characterLimit = self.pinLength
        var placeholderText = ""
        for _ in 0..<self.pinLength{
            placeholderText.append("◦")
        }
        self.pinView.placeholderTextString = placeholderText
        self.pinView.text = ""

        self.pinView.setNeedsDisplay()
        self.pinView.layoutIfNeeded()
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }
}

extension SettingsPasscodeNewViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        textField.text = nil
        return true
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        if let pin = textField.text {
            self.pinCode = pin

            navigateToSettingsPasscodeRepeat(firstPin: pinCode)
        }
        return true
    }
}
