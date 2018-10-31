//
//  SignUpViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import LinkedInSignIn

class SignUpViewController: BaseViewController, Messageable, Loadable {
    
    @IBOutlet weak private var signupButton: UIButton!
    @IBOutlet weak private var loginTextField: ClearTextField!
    @IBOutlet weak private var passwordTextField: ClearTextField!
    @IBOutlet weak private var passwordConfirmTextField: ClearTextField!

    @IBOutlet weak var lineUpLeftView: UIView!
    @IBOutlet weak var lineUpRightView: UIView!
    @IBOutlet weak var lineUpText: UILabel!

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
    
    var passwordConfirm: String {
        get { return passwordConfirmTextField.text ?? "" }
        set { passwordConfirmTextField.text = newValue }
    }
    
    var isPasswordConfirmValid: Bool? = nil {
        didSet {
            if let passwordValid = isPasswordConfirmValid {
                passwordConfirmTextField.validationState = passwordValid ? .ok : .error
                changeButton(state: allFieldsValid())
                
            } else {
                passwordConfirmTextField.validationState = .none
            }
        }
    }

    var signUpNetwork: SocialNetworkType?

    var errorPopup: ErrorInputView?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
        //applyTest()
    }

    func applyTest() {
        loginTextField.text = "test@test.ru"
        passwordTextField.text = "test"
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            return .lightContent
        }
        return .default
    }
    
    override func resignFirstResponder() -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    @objc func dissmisKeygoard(gesture: UITapGestureRecognizer) {
        _ = resignFirstResponder()
    }
    @IBAction func singupButtonTouched(_ sender: Any) {
        signUpNetwork = nil
        submit(login: login, password: password)
    }
    @IBAction func facebookButtonTouched(_ sender: Any) {
        signUpNetwork = .facebook
        showTerms()
    }

    func facebookAction() {
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
        signUpNetwork = .google
        showTerms()
    }

    func googleAction() {
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func linkedButtonTouched(_ sender: Any) {
        signUpNetwork = .linkedin
        showTerms()
    }

    func linkedinAction() {
        let linkedInConfig = LinkedInConfig(linkedInKey: Environment().configuration(PlistKey.LinkedInKey), linkedInSecret: Environment().configuration(PlistKey.LinkedInSecret), redirectURL: WalletConstants.linkedInRedirectURL, scope: "r_basicprofile%20r_emailaddress")
        let linkedInHelper = LinkedinHelper(linkedInConfig: linkedInConfig)

        linkedInHelper.login(from: self, completion: { [weak self] accessToken in
            self?.loginSocial(networkType: .linkedin, token: accessToken)
        }, failure: { error in
            print(error.localizedDescription)
        }, cancel: {  })
    }

    @IBAction func kakaoButtonTouched(_ sender: Any) {
        signUpNetwork = .kakao
        showTerms()
    }

    func kakaoAction() {
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
        signUpNetwork = .weibo
        showTerms()
    }

    func weiboAction() {
        WeiboSDK.registerApp(Environment().configuration(PlistKey.WeiboAppKey))

        WeiboSDK.enableDebugMode(true)


        //let authorizeRequest = WBAuthorizeRequest()
        let authorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        authorizeRequest.redirectURI = WalletConstants.weiboRedirectURL
        authorizeRequest.scope = "all"

        WeiboSDK.send(authorizeRequest)
    }

    @IBAction func twitterButtonTouched(_ sender: Any) {
        signUpNetwork = .twitter
        showTerms()
    }

    func twitterAction() {
        TWTRTwitter.sharedInstance().start(withConsumerKey: Environment().configuration(PlistKey.TwitterConsumerKey), consumerSecret: Environment().configuration(PlistKey.TwitterConsumerSecret))

        TWTRTwitter.sharedInstance().logIn(with: self) { [weak self] (session, error) in
            if let session = session {
                self?.loginSocial(networkType: .twitter, token: session.authToken)
            }
        }
    }
    
    @objc func backAction() {
        navigateToBack()
    }

    func clearAllErrors() {
        loginTextField.validationState = .none
        passwordTextField.validationState = .none
        passwordConfirmTextField.validationState = .none
    }

    private func submit(login: String, password: String) {

        clearAllErrors()
        _ = resignFirstResponder()

        if !login.isValidEmail {
            loginTextField.validationState = .error
            showErrorMessage(text: "common.erroremail".localized(), textFiled: loginTextField)
            return
        }

        if Validator.hasValidLoginCredentials(login: login, password: password, confirmPassword: passwordConfirm) {
            if password != passwordConfirm {
                passwordConfirmTextField.validationState = .error
                showErrorMessage(text: "common.errorpassword".localized(), textFiled: passwordConfirmTextField)
            } else {
                showTerms()
            }
            //loginNosocial(login: login, password: password)
        } else {
            if let errorTitle = Validator.invalidLoginCredentialsReason(login: login, password: password) {
                if password.isEmpty {
                    passwordTextField.validationState = .error
                    showErrorMessage(text: errorTitle, textFiled: passwordTextField)
                } else {
                    if Validator.isValidPassword(password) {
                        if password != passwordConfirm {
                            passwordConfirmTextField.validationState = .error
                            showErrorMessage(text: "common.errorpassword".localized(), textFiled: passwordConfirmTextField)
                        } else {
                            showMessage(title: errorTitle, message: nil)
                        }
                    } else {
                        showMessage(title: errorTitle, message: nil)
                    }

                }
            } else {
                if password != passwordConfirm {
                    passwordConfirmTextField.validationState = .error
                    showErrorMessage(text: "common.errorpassword".localized(), textFiled: passwordConfirmTextField)
                }
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
        signupButton.isEnabled = state
    }

    override func configureView(isRefresh: Bool) {

        self.navigationController?.isNavigationBarHidden = false

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        title = "common.screens.signup".localized()

        self.view.backgroundColor = Color(componentType: .viewBackground)

        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            lineUpLeftView.alpha = 0.3
            lineUpRightView.alpha = 0.3
            lineUpText.alpha = 0.3
        }
        
        self.signupButton.isEnabled = false
        self.signupButton.setTitle("common.actions.signup".localized().uppercased(), for: .normal)
        self.signupButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        self.signupButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)
        
        self.signupButton.backgroundColor = Color(componentType: .buttonFill)
        self.signupButton.layer.cornerRadius = 5
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeygoard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let leftBarButton = NavigationButton(type: .backIcon, target: self, action: #selector(backAction))
        leftBarButton.tintColor = Color(componentType: .button)
        self.navigationItem.leftBarButtonItem = leftBarButton

        let currentWidth = (self.view.bounds.width - 7*10)/5
        iconsWidthConstraint.constant = currentWidth
    }


    func loginNosocial(login: String, password: String) {
        self.showLoader()
        StorageManager.shared.clean()

        DataManager.shared.signUp(email: login, password: password) { [weak self] (authModel, error, errorString) in
            if error == nil {
                self?.hideLoaderSuccess()
                KeychainManager.shared.setUsername(value: login)
                KeychainManager.shared.setPassword(value: password)
                DefaultsManager.shared.socialNetworkLoginType = nil
                KeychainManager.shared.removeSocialToken()
                BaseViewController.resetRootToCreatePasscodeController()
            } else {
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Registration failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Registration failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Registration failed", errorLabelMessage: "Unknown Error")
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

    func showTerms() {

        DispatchQueue.main.async {
            let controller = R.storyboard.signUp.termsNavController()
            if let controllerTerm = controller?.viewControllers.first as? TermsViewController {
                controllerTerm.delegate = self
            }
            self.present(controller!, animated: true, completion: nil)
        }
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

extension SignUpViewController: UITextFieldDelegate {
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
            _ = passwordConfirmTextField.becomeFirstResponder()
            return true
        case passwordConfirmTextField:
            submit(login: login, password: password)
            return false
        default:
            return true
        }
    }
}

extension SignUpViewController: GIDSignInUIDelegate {

}

extension SignUpViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print(user)
            let token = user.authentication.accessToken
            print(user.description)

            #if DEBUG
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

extension SignUpViewController: TermsViewControllerDelegate {
    func termsViewControllerAction(_ termsViewController: TermsViewController) {

        if signUpNetwork == nil {
            loginNosocial(login: login, password: password)
            return
        }

        switch signUpNetwork! {
        case .facebook:
            facebookAction()
        case .google:
            googleAction()
        case .linkedin:
            linkedinAction()
        case .kakao:
            kakaoAction()
        case .weibo:
            weiboAction()
        case .twitter:
            twitterAction()
        }
    }
}
