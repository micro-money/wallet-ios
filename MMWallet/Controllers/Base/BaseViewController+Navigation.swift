//
//  BaseViewController+Navigation.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

extension BaseViewController {
    
    //MARK: - Start navigation
    
    class func resetToRootController() {
        NotificationCenter.default.post(name: .resetRootControllerNotificationName, object: nil)
    }

    class func resetRootToDashboardController() {
        NotificationCenter.default.post(name: .resetRootToDashboardControllerNotificationName, object: nil)
    }

    class func resetRootToCreatePasscodeController() {
        NotificationCenter.default.post(name: .resetRootToCreatePasscodeControllerNotificationName, object: nil)
    }

    class func resetRootToSignInController() {
        NotificationCenter.default.post(name: .resetRootToSignInControllerNotificationName, object: nil)
    }

    func resetRootController() {
        BaseViewController.resetToRootController()
    }
    
    func navigateToSignUp() {
        let controller = R.storyboard.signUp.signUpViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToDashboard() {
        let controller = R.storyboard.dashboard.dashboardTabController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToCreatePasscodeConfirmPin(firstPin: String) {
        let controller = R.storyboard.createPasscode.confirmPinViewController()
        controller?.applyData(firstPin: firstPin)
        pushTo(controller: controller, animated: true)
    }

    func navigateToCreatePasscodeFaceId() {
        let controller = R.storyboard.createPasscode.faceViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToCreatePasscodeTouchId() {
        let controller = R.storyboard.createPasscode.touchIdViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToNewAssetToken() {
        let controller = R.storyboard.dashboard.newAssetTokenViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToNewAssetCryptoNew(isImport: Bool = false) {
        let controller = R.storyboard.dashboard.newAssetCryptoNewViewController()
        controller?.applyData(isImport: isImport)
        pushTo(controller: controller, animated: true)
    }

    func navigateToNewAssetCryptoName(currency: String) {
        let controller = R.storyboard.dashboard.newAssetCryptoNameViewController()
        controller?.applyData(currency: currency)
        pushTo(controller: controller, animated: true)
    }

    func navigateToAssetsDetail(assetsId: Int) {

        DispatchQueue.main.async {
            let controller = R.storyboard.assetDetail.assetDetailNavigationController()
            let transitionDelegate = DeckTransitioningDelegate()
            controller?.transitioningDelegate = transitionDelegate
            controller?.modalPresentationStyle = .custom
            if let detailController = controller?.viewControllers.first as? AssetDetailViewController {
                detailController.applyData(assetsId: assetsId)
            }
            self.present(controller!, animated: true, completion: nil)
        }
    }

    func navigateToSend(assetsId: Int) {
        let controller = R.storyboard.send.sendViewController()
        controller?.applyData(assetsId: assetsId)
        //present(controller!, animated: true)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSend(assetsId: Int, address: String) {
        let controller = R.storyboard.send.sendViewController()
        controller?.applyData(assetsId: assetsId, address: address)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSendModal(assetsId: Int, address: String) -> SendViewController? {

        let controller = R.storyboard.send.sendViewController()
        DispatchQueue.main.async {
            let transitionDelegate = DeckTransitioningDelegate()
            controller?.transitioningDelegate = transitionDelegate
            controller?.modalPresentationStyle = .custom
            controller?.applyData(assetsId: assetsId, address: address)
            self.present(controller!, animated: true, completion: nil)
        }

        return controller
    }

    func navigateToSettingsExportSelect() {
        let controller = R.storyboard.dashboard.settingsExportSelectViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsAssets(currency: String?, exportType: ExportType) {
        let controller = R.storyboard.dashboard.settingsAssetsViewController()
        controller?.applyData(currency: currency, exportType: exportType)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsAppearance() {
        let controller = R.storyboard.dashboard.settingsAppearanceViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsExportKey(assetId: Int) {
        let controller = R.storyboard.dashboard.settingsExportKeyViewController()
        controller?.applyData(assetId: assetId)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsExportKeystore(assetId: Int) {
        let controller = R.storyboard.exportKeystore.exportKeystoreViewController()
        controller?.applyData(assetId: assetId)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsExportKeys(assetId: Int) {
        let controller = R.storyboard.dashboard.settingsExportKeysViewController()
        controller?.applyData(assetId: assetId)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsPasscode() {
        let controller = R.storyboard.settings.settingsPasscodeViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsPasscodeNew() {
        let controller = R.storyboard.settings.settingsPasscodeNewViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToSettingsPasscodeRepeat(firstPin: String) {
        let controller = R.storyboard.settings.settingsPasscodeRepeatViewController()
        controller?.applyData(firstPin: firstPin)
        pushTo(controller: controller, animated: true)
    }

    func navigateToSearchToken() {
        let controller = R.storyboard.dashboard.newAssetTokenSearchViewController()
        pushTo(controller: controller, animated: true)
    }

    func navigateToNewAssetImportToken(address: String?) {
        let controller = R.storyboard.importToken.importTokenViewController()
        controller?.applyData(address: address)
        pushTo(controller: controller, animated: true)
    }

    func navigateBackToSettings() {

        if navigationController != nil {
            for aViewController in navigationController!.viewControllers {
                if aViewController is SettingsViewController {
                    navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
    
    func navigateToBack() {

        if navigationController == nil {
            dismiss(animated: true)
            return
        }

        navigationController?.popViewController(animated: true)
    }
    
    //MARK: navigation helpers
    
    private func pushTo(controller: UIViewController?, animated: Bool) {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func setEmptyBackBarItem() {
        setBackBarItemWith(title: "")
    }
    
    private func setBackBarItemWith(title: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }
}
