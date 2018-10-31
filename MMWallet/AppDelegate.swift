//
//  AppDelegate.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 13.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import FacebookCore
import GoogleSignIn
import IQKeyboardManagerSwift
import LinkedInSignIn
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        GIDSignIn.sharedInstance().clientID = Environment().configuration(PlistKey.GoogleClientID)
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.statusBarStyle = .lightContent
        
        configureRootNavigationObservers()

        if DefaultsManager.shared.isDarkTheme == nil {
            DefaultsManager.shared.isDarkTheme = false
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "common.actions.done".localized()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }

        let urlString = url.absoluteString
        if urlString.contains(find: Environment().configuration(PlistKey.WeiboAppKey)) {
            return WeiboSDK.handleOpen(url, delegate: self)
        }

        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }

        let urlString = url.absoluteString
        if urlString.contains(find: Environment().configuration(PlistKey.WeiboAppKey)) {
            return WeiboSDK.handleOpen(url, delegate: self)
        }

        let googleSession = GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication, annotation: annotation)
        return googleSession
    }

    private func configureRootNavigationObservers() {
        NotificationCenter.default.addObserver(forName: .resetRootControllerNotificationName, object: nil, queue: nil) { [unowned self] _ in
            self.resetToRootController()
        }

        NotificationCenter.default.addObserver(forName: .resetRootToDashboardControllerNotificationName, object: nil, queue: nil) { [unowned self] _ in
            self.setRootToDashboardScreen()
        }

        NotificationCenter.default.addObserver(forName: .resetRootToCreatePasscodeControllerNotificationName, object: nil, queue: nil) { [unowned self] _ in
            self.setRootToCreatePasscodeScreen()
        }

        NotificationCenter.default.addObserver(forName: .resetRootToSignInControllerNotificationName, object: nil, queue: nil) { [unowned self] _ in
            self.setRootToSigInScreen()
        }
    }

    var rootViewController : UIViewController? {

        if DefaultsManager.shared.isPinLogin != nil {
            if KeychainManager.shared.pin != nil {
                if !KeychainManager.shared.pin!.isEmpty {
                    return R.storyboard.pinCode.pinCodeViewController()
                }
            }
        }

        return R.storyboard.signIn.signViewController()
    }

    func setRootToDashboardScreen() {
        rootTransitionWith(controller: R.storyboard.dashboard.dashboardTabController())
    }

    func setRootToCreatePasscodeScreen() {
        rootTransitionWith(controller: R.storyboard.createPasscode.createPasscodeViewController())
    }

    func setRootToSigInScreen() {
        rootTransitionWith(controller: R.storyboard.signIn.signViewController())
    }
    
    func resetToRootController() {
        
        /*
         if let _ = self.window?.rootViewController?.presentedViewController {
         self.window?.rootViewController?.dismiss(animated: true, completion: { [unowned self] in
         self.resetToRootController()
         return
         })
         }*/
        
        guard let _ = window else {
            return
        }
        
        rootTransitionWith(controller: self.rootViewController)
    }
    
    func rootTransitionWith(controller: UIViewController?) {
        guard let controller = controller else {
            return
        }
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: { [unowned self] in
            UIView.performWithoutAnimation {
                self.window?.rootViewController = controller
            }
        })
    }
}


extension AppDelegate: WeiboSDKDelegate {

    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {

    }

    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if let authorizeResponse = response as? WBAuthorizeResponse {
            if authorizeResponse.accessToken != nil {
                NotificationCenter.default.post(name: .networkWeiboAuthorizeResponseNotificationName, object: self, userInfo: ["accessToken": authorizeResponse.accessToken!, "userId": authorizeResponse.userID!])
            }
            //authorizeResponse.accessToken
        }
    }
}
