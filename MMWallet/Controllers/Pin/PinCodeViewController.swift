//
//  PinCodeViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 19.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import LocalAuthentication

extension PinCodeViewController {
    enum RightButtonMode: Int {
        case none = 0
        case biometry
        case backspace
    }
}
class PinCodeViewController: BaseViewController, Messageable, Loadable {
    
    var rightButtonMode: RightButtonMode = .none {
        didSet {
            switch rightButtonMode {
            case .none:
                rightButton.setImage(nil, for: .normal)
            case .biometry:
                if FaceId.isSupported {
                    let rightButtonImage = R.image.faceIdButtonIcon()
                    rightButton.setImage(rightButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
                } else {
                    let rightButtonImage = R.image.touchIdButtonIcon()
                    rightButton.setImage(rightButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
                }
            case .backspace:
                rightButton.setImage(R.image.backspaceIcon(), for: .normal)
            }
        }
    }
    @IBOutlet weak var pinCodeTextField: PinCodeTextField! {
        didSet {
            pinCodeTextField.textColor = UIColor(componentType: .navigationText)
            pinCodeTextField.placeholderColor = UIColor(componentType: .navigationText)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var logoView: UIImageView! {
        didSet {
            if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                logoView.image = R.image.navLogoWhite()
            }
        }
    }
    
    @IBOutlet private var keyButtons: [UIButton]!
    @IBOutlet private var rightButton: UIButton!

    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    var currentPin = ""

    var isLoginProcess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            return .lightContent
        }
        return .default
    }

    override func configureView(isRefresh: Bool) {

        currentPin = KeychainManager.shared.pin!

        titleLabel.textColor = UIColor(componentType: .navigationText)
        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        pinCodeTextField.textColor = UIColor(componentType: .navigationText)
        pinCodeTextField.placeholderColor = UIColor(componentType: .navigationText)

        for button in keyButtons {
            button.setTitleColor(UIColor(componentType: .keyPadText), for: .normal)
            button.backgroundColor = Color(componentType: .keyPad)
            button.setBackgroundColor(Color(componentType: .keyPad), for: .normal)
            button.setCornerRadius(radius: buttonHeightConstraint.constant/2)
            button.addTarget(self, action: #selector(PinCodeViewController.buttonTapped(_:)), for: .touchUpInside)
        }
        rightButton.setTitleColor(UIColor(componentType: .keyPadText), for: .normal)
        rightButton.backgroundColor = Color(componentType: .keyPad)
        rightButton.setCornerRadius(radius: buttonHeightConstraint.constant/2)
        rightButton.setBackgroundColor(Color(componentType: .keyPad), for: .normal)
        rightButton.addTarget(self, action: #selector(PinCodeViewController.rightButtonTapped(_:)), for: .touchUpInside)
        rightButtonMode = .biometry

        if DefaultsManager.shared.isBioLogin == nil {
            rightButtonMode = .backspace
            rightButton.isHidden = true
        }

        pinCodeTextField.characterLimit = currentPin.count
        var placeholderText = ""
        for _ in 0..<pinCodeTextField.characterLimit{
            placeholderText.append("◦")
        }
        pinCodeTextField.placeholderTextString = placeholderText
        pinCodeTextField.text = ""

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //self.pinCodeTextField.textColor = UIColor(componentType: .navigationText)
            //self.pinCodeTextField.placeholderColor = UIColor(componentType: .navigationText)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {

        if let numberString = sender.titleLabel?.text {
            pinCodeTextField.insertText(numberString)
            rightButtonMode = .backspace
            rightButton.isHidden = false
        }

        if !pinCodeTextField.canInsertCharacter("0") {
            if isLoginProcess {
                return
            }
            isLoginProcess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                guard let stringPin = self.pinCodeTextField.text else { return }
                if stringPin == self.currentPin {
                    self.signIn()
                } else {
                    self.pinCodeTextField.text = ""
                    self.rightButtonMode = .biometry
                    if DefaultsManager.shared.isBioLogin == nil {
                        self.rightButton.isHidden = true
                    }
                }
            }
        }
    }

    @objc func rightButtonTapped(_ sender: UIButton) {

        if rightButtonMode == .backspace {
            pinCodeTextField.deleteBackward()
            if pinCodeTextField.text!.isEmpty {
                if DefaultsManager.shared.isBioLogin == nil {
                    rightButton.isHidden = true
                } else {
                    rightButtonMode = .biometry
                }
            }
        } else {
            biometryAction()
        }
    }

    func clearPinAction() {
        self.pinCodeTextField.text = ""
        self.rightButtonMode = .biometry
        if DefaultsManager.shared.isBioLogin == nil {
            self.rightButton.isHidden = true
        } else {
            self.rightButton.isHidden = false
        }
    }

    func biometryAction() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in

                DispatchQueue.main.async {
                    if success {
                        self.signIn()
                    } else {
                        print("error biometry")
                    }
                }
            }
        } else {
            print("no biometry")
        }
    }

    func signIn() {

        isLoginProcess = true
        //BaseViewController.resetRootToDashboardController()

        if DefaultsManager.shared.socialNetworkLoginType != nil {
            if let token = KeychainManager.shared.socialToken {
                loginSocial(token: token, networkType: SocialNetworkType(rawValue: DefaultsManager.shared.socialNetworkLoginType!)!)
            }
            return
        }

        if let username = KeychainManager.shared.username, let password = KeychainManager.shared.password {
            loginNosocial(login: username, password: password)
        }
    }

    func loginNosocial(login: String, password: String) {
        self.showLoader()

        StorageManager.shared.clean()
        DataManager.shared.signIn(email: login, password: password) { [weak self] (authModel, error, errorString) in
            self?.isLoginProcess = false
            if error == nil {
                DataManager.shared.getWallet(isNeedFromCache: false) { [weak self] (walletModel, error) in

                    self?.hideLoaderSuccess() {
                        BaseViewController.resetRootToDashboardController()
                    }
                }
            } else {
                self?.clearPinAction()
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _errorString) {
                        BaseViewController.resetRootToSignInController()
                    }
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _error.getErrorString()) {
                        BaseViewController.resetRootToSignInController()
                    }
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: "Unknown Error") {
                    BaseViewController.resetRootToSignInController()
                }
            }
        }
    }

    func loginSocial(token: String, networkType: SocialNetworkType) {
        self.showLoader()

        StorageManager.shared.clean()

        DataManager.shared.signSocial(networkType: networkType, token: token, userId: KeychainManager.shared.socialId) { [weak self] (authModel, error, errorString) in
            self?.isLoginProcess = false
            if error == nil {
                DataManager.shared.getWallet(isNeedFromCache: false) { [weak self] (walletModel, error) in

                    /*
                    if let walletModel = walletModel {
                        if walletModel.mnemonic == false {
                            self?.hideLoaderSuccess()
                            BaseViewController.resetRootToRegistrationController()
                            return
                        }
                    }
                    */

                    self?.hideLoaderSuccess() {
                        BaseViewController.resetRootToDashboardController()
                    }
                }
            } else {
                self?.clearPinAction()
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _errorString) {
                        BaseViewController.resetRootToSignInController()
                    }
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _error.getErrorString()) {
                        BaseViewController.resetRootToSignInController()
                    }
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: "Unknown Error") {
                    BaseViewController.resetRootToSignInController()
                }
            }
        }
    }
}
