//
//  SignInViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import LinkedInSignIn
import Crashlytics

class SignInViewController: BaseViewController, Messageable, Loadable {

    @IBOutlet weak var logoView: UIImageView! {
        didSet {
            if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                logoView.image = R.image.navLogoWhite()
            }
        }
    }
    @IBOutlet weak var lineUpLeftView: UIView!
    @IBOutlet weak var lineUpRightView: UIView!
    @IBOutlet weak var lineUpText: UILabel!
    @IBOutlet weak var lineDownView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak private var singinButton: UIButton!
    @IBOutlet weak private var signupButton: UIButton!
    @IBOutlet weak private var signupLabel: UILabel!
    @IBOutlet weak private var loginTextField: ClearTextField!
    @IBOutlet weak private var passwordTextField: ClearTextField!
    @IBOutlet weak var iconsWidthConstraint: NSLayoutConstraint!
    
    var login: String {
        get { return loginTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "" }
        set { loginTextField.text = newValue }
    }
    var isLoginValid: Bool? = nil {
        didSet {
            if let loginValid = isLoginValid {
                loginTextField.validationState = loginValid ? .ok : .error
                changeButton(state: allFieldsValid())
            } else {
                loginTextField.validationState = .none
            }
        }
    }
    var password: String {
        get { return passwordTextField.text ?? "" }
        set { passwordTextField.text = newValue }
    }
    var isPasswordValid: Bool? = nil {
        didSet {
            if let passwordValid = isPasswordValid {
                passwordTextField.validationState = passwordValid ? .ok : .error
                changeButton(state: allFieldsValid())
                
            } else {
                passwordTextField.validationState = .none
            }
        }
    }

    var errorPopup: ErrorInputView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DefaultsManager.shared.isPinLogin = nil

        configureView(isRefresh: false)

        NotificationCenter.default.addObserver(forName: .networkWeiboAuthorizeResponseNotificationName, object: nil, queue: nil) { [weak self] notification in
            if let token = notification.userInfo?["accessToken"] as? String, let userId = notification.userInfo?["userId"] as? String {
                self?.loginSocial(networkType: .weibo, token: token, userId: userId)
            }
        }
    }

    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Wallet v\(version) (\(build))"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        //NotificationCenter.default.addObserver(forName: .networkWeiboAuthorizeResponseNotificationName, object: nil, queue: nil) { [weak self] notification in
        //    if let token = notification.userInfo?["accessToken"] as? String, let userId = notification.userInfo?["userId"] as? String {
        //        self?.loginSocial(networkType: .weibo, token: token, userId: userId)
        //    }
        //}
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //NotificationCenter.default.removeObserver(self, name: .networkWeiboAuthorizeResponseNotificationName, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            return .lightContent
        }
        return .default
    }

    override func configureView(isRefresh: Bool) {

        self.navigationController?.isNavigationBarHidden = true

        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeygoard(gesture:)))
        view.addGestureRecognizer(tapGesture)

        self.view.backgroundColor = Color(componentType: .viewBackground)

        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            lineUpLeftView.alpha = 0.3
            lineUpRightView.alpha = 0.3
            lineDownView.alpha = 0.3
            lineUpText.alpha = 0.3
        }

        versionLabel.text = version()
        versionLabel.textColor = UIColor(componentType: .textVersion)

        self.singinButton.isEnabled = false
        self.singinButton.setTitle("common.actions.signin".localized().uppercased(), for: .normal)
        self.singinButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        self.singinButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)
        self.singinButton.backgroundColor = Color(componentType: .buttonFill)
        self.singinButton.layer.cornerRadius = 5

        self.signupLabel.text = "signin.info.donthaveaccount".localized()
        self.signupLabel.textColor = Color(componentType: .labelPlaceholder)

        self.signupButton.setTitle("common.actions.signup".localized(), for: .normal)
        self.signupButton.setTitleColor(Color(componentType: .button), for: .normal)

        loginTextField.delegate = self
        passwordTextField.delegate = self

        loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let currentWidth = (self.view.bounds.width - 7*10)/5
        iconsWidthConstraint.constant = currentWidth
    }

    override func resignFirstResponder() -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    @objc func dissmisKeygoard(gesture: UITapGestureRecognizer) {
        _ = resignFirstResponder()
    }
    // MARK: - Actions
    @IBAction func singinButtonTouched(_ sender: Any) {
        loginNosocial(login: login, password: password)
    }
    @IBAction func singupButtonTouched(_ sender: Any) {
        navigateToSignUp()
    }
    @IBAction func facebookButtonTouched(_ sender: Any) {

        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { [weak self] (result) in
            switch result {
            case let .success(_, _, token):
                self?.loginSocial(networkType: .facebook, token: token.authenticationToken)
            case .failed(_):
                self?.hideLoaderFailure()
            case .cancelled:
                self?.hideLoaderFailure()
            }
        }
    }
    @IBAction func googleButtonTouched(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func linkedButtonTouched(_ sender: Any) {

        let linkedInConfig = LinkedInConfig(linkedInKey: Environment().configuration(PlistKey.LinkedInKey), linkedInSecret: Environment().configuration(PlistKey.LinkedInSecret), redirectURL: WalletConstants.linkedInRedirectURL, scope: "r_basicprofile%20r_emailaddress")
        let linkedInHelper = LinkedinHelper(linkedInConfig: linkedInConfig)

        linkedInHelper.login(from: self, completion: { [weak self] accessToken in
            self?.loginSocial(networkType: .linkedin, token: accessToken)
        }, failure: { error in
            print(error.localizedDescription)
        }, cancel: {  })
    }

    @IBAction func kakaoButtonTouched(_ sender: Any) {

        let session :KOSession = KOSession.shared()

        if session.isOpen() {
            session.close()
        }

        session.presentingViewController = self
        session.open(completionHandler: {[weak self] (error) -> Void in
            if error == nil {
                if session.accessToken != nil {
                    self?.loginSocial(networkType: .kakao, token: session.accessToken!)
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        })

    }

    @IBAction func weiboButtonTouched(_ sender: Any) {

        WeiboSDK.registerApp(Environment().configuration(PlistKey.WeiboAppKey))

        WeiboSDK.enableDebugMode(true)

        let authorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        authorizeRequest.redirectURI = WalletConstants.weiboRedirectURL
        authorizeRequest.scope = "all"

        WeiboSDK.send(authorizeRequest)


    }

    @IBAction func twitterButtonTouched(_ sender: Any) {

        TWTRTwitter.sharedInstance().start(withConsumerKey: Environment().configuration(PlistKey.TwitterConsumerKey), consumerSecret: Environment().configuration(PlistKey.TwitterConsumerSecret))

        TWTRTwitter.sharedInstance().logIn(with: self) { [weak self] (session, error) in
            if let session = session {
                self?.loginSocial(networkType: .twitter, token: session.authToken)
            }
        }
    }

    func loginNosocial(login: String, password: String) {
        self.showLoader()
        StorageManager.shared.clean()
        DataManager.shared.signIn(email: login, password: password) { [weak self] (authModel, error, errorString) in
            if error == nil {
                DataManager.shared.getWallet(isNeedFromCache: false) { [weak self] (walletModel, error) in

                    SessionManager.shared.start(words: password)
                    self?.hideLoaderSuccess()

                    if DefaultsManager.shared.isPinLogin == nil {
                        KeychainManager.shared.setUsername(value: login)
                        KeychainManager.shared.setPassword(value: password)
                        DefaultsManager.shared.socialNetworkLoginType = nil
                        KeychainManager.shared.removeSocialToken()
                        BaseViewController.resetRootToCreatePasscodeController()
                        return
                    }

                    BaseViewController.resetRootToDashboardController()
                }
            } else {
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: "Unknown Error")
            }
        }
    }

    func loginSocial(networkType: SocialNetworkType, token: String, userId: String? = nil) {
        self.showLoader()
        StorageManager.shared.clean()

        DataManager.shared.signSocial(networkType: networkType ,token: token, userId: userId) { [weak self] (authModel, error, errorString) in
            if error == nil {
                DataManager.shared.getWallet(isNeedFromCache: false) { [weak self] (walletModel, error) in

                    self?.hideLoaderSuccess()

                    if DefaultsManager.shared.isPinLogin == nil {
                        KeychainManager.shared.removeUsername()
                        KeychainManager.shared.removePassword()
                        DefaultsManager.shared.socialNetworkLoginType = networkType.rawValue
                        KeychainManager.shared.setSocialToken(value: token)
                        if userId != nil {
                            KeychainManager.shared.setSocialId(value: userId!)
                        }
                        BaseViewController.resetRootToCreatePasscodeController()
                        return
                    }

                    BaseViewController.resetRootToDashboardController()
                }
            } else {
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Sign In failed", errorLabelMessage: "Unknown Error")
            }
        }
    }

    func clearAllErrors() {
        loginTextField.validationState = .none
        passwordTextField.validationState = .none
    }

    private func submit(login: String, password: String) {

        clearAllErrors()
        _ = resignFirstResponder()

        if Validator.hasValidLoginCredentials(login: login, password: password) {
            loginNosocial(login: login, password: password)
        } else {
            if let errorTitle = Validator.invalidLoginCredentialsReason(login: login, password: password) {
                if !login.isValidEmail {
                    loginTextField.validationState = .error
                    showErrorMessage(text: errorTitle, textFiled: loginTextField)
                } else {
                    if password.isEmpty {
                        passwordTextField.validationState = .error
                        showErrorMessage(text: errorTitle, textFiled: passwordTextField)
                    } else {
                        loginTextField.validationState = .error
                        passwordTextField.validationState = .error
                    }

                }
                //showMessage(title: errorTitle, message: nil)
            }
        }

    }
    private func validate(login: String, password: String) {
        if Validator.isValidLogin(login) {
            isLoginValid = true
        } else {
            isLoginValid = nil
        }
        if Validator.isValidPassword(password) {
            isPasswordValid = true
        } else {
            isPasswordValid = nil
        }
    }
    private func allFieldsValid() -> Bool {
        if let loginValid = isLoginValid, let passwordValid = isPasswordValid {
            return loginValid && passwordValid
        } else {
            return false
        }
    }
    private func changeButton(state: Bool) {
        singinButton.isEnabled = state
    }

    func showErrorMessage(text: String, textFiled: ClearTextField) {

        if errorPopup == nil {
            errorPopup = R.nib.errorInputView.firstView(owner: nil)
            self.view.addSubview(errorPopup!)
            errorPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(textFiled).offset(-10)
                make.centerX.equalTo(textFiled)
                make.width.equalTo(175)
                make.height.equalTo(47)
            }
            errorPopup?.alpha = 0
            errorPopup?.applyData(textString: text)

            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.errorPopup?.alpha = 1
            }, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.errorPopup?.alpha = 0
                }) { [weak self] complete in
                    self?.errorPopup?.removeFromSuperview()
                    self?.errorPopup = nil
                }
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        validate(login: login, password: password)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            _ = passwordTextField.becomeFirstResponder()
            return true
        case passwordTextField:
            submit(login: login, password: password)
            return false
        default:
            return true
        }
    }
}

extension SignInViewController: GIDSignInUIDelegate {

}


extension SignInViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print(user)
            let token = user.authentication.accessToken
            //let refr = user.authentication.refreshToken
            #if DEBUG
            print(user.description)

            print("========")
            print(user.authentication.accessToken)
            print(user.authentication.accessTokenExpirationDate)
            print(user.authentication.refreshToken)
            print(user.authentication.clientID)
            print(user.authentication.idToken)
            print(user.authentication.idTokenExpirationDate)
            #endif

            loginSocial(networkType: .google, token: token!)
        }
    }

}
