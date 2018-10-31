//
//  CreatePinViewController.swift
//  Wallet
//
//  Created by Oleg Leizer on 15.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit

class CreatePinViewController: BaseViewController, UIAlertViewDelegate, PinCodeTextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pinView: PinCodeTextField!
    var pinCode: String?
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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pinView.text = ""
        pinCode = ""
        pinView.becomeFirstResponder()

    }
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func configureView(isRefresh: Bool) {
        self.navigationController?.navigationBar.tintColor = Color(.primary)
        pinView.delegate = self
        pinView.keyboardType = .numberPad

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        pinView.textColor = UIColor(componentType: .navigationText)
        pinView.placeholderColor = UIColor(componentType: .navigationText)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "setuppin.settings.welcome".localized()
    }

// MARK: - PinCodeTextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        textField.text = nil
        return true
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        if let pin = textField.text {
            self.pinCode = pin
            navigateToCreatePasscodeConfirmPin(firstPin: pin)
        }
        return true
    }

    @objc func nextAction() {
        guard let stringPin = pinView.text else { return }
        pinCode = stringPin
        navigateToCreatePasscodeConfirmPin(firstPin: pinCode!)
    }
    @objc func backAction() {
        navigateToBack()
    }
    @IBAction func settingButtonTouched(_ sender: Any) {
//        pinView.resignFirstResponder()

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmPinSegue" {
            if let destinationVC = segue.destination as? ConfirmPinViewController {
                destinationVC.firstPin = pinCode
            }
        }
    }

    private func updatePinField() {
        pinView.characterLimit = pinLength
        var placeholderText = ""
        for _ in 0..<pinLength{
            placeholderText.append("◦")
        }
        pinView.placeholderTextString = placeholderText
        pinView.text = ""
        
        self.view.setNeedsDisplay()

    }
}
