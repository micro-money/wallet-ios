//
//  ExportKeystoreViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 12.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import CarbonKit

enum ExportKeystoreViewType: String {
    case bystore = "bystore"
    case byqr = "byqr"
}

struct ExportKeystoreViewCategory {
    var title: String
    var type: ExportKeystoreViewType?
}

class ExportKeystoreViewController: BaseViewController, Loadable {

    @IBOutlet fileprivate var containerView: UIView!
    @IBOutlet fileprivate var carbonToolbar: UIToolbar!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    fileprivate var carbonTabSwipeNavigation: CarbonTabSwipeNavigation?
    @IBOutlet weak var lineView: UIView!

    fileprivate var items: [ExportKeystoreViewCategory] {
        let itemsArray = [ExportKeystoreViewCategory(title: "Keystore", type: .bystore),
                          ExportKeystoreViewCategory(title: "QR code", type: .byqr)]
        return itemsArray
    }

    var assetId: Int = 0

    var keystorePasswordString = ""
    var passwordString = ""
    var enterPasswordView: EnterPasswordView?

    var exportKeystoreModels: [ExportKeystoreModel]? {
        didSet {
            exportKeystoreStoreViewController?.exportKeystoreModels = exportKeystoreModels
            exportKeystoreQRViewController?.exportKeystoreModels = exportKeystoreModels
        }
    }
    var exportKeystoreStoreViewController: ExportKeystoreStoreViewController?
    var exportKeystoreQRViewController: ExportKeystoreQRViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    func applyData(assetId: Int) {
        self.assetId = assetId
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func configureView(isRefresh: Bool) {

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        carbonToolbar.barTintColor = UIColor(componentType: .viewBackground)
        lineView.backgroundColor = UIColor(componentType: .carbonLine)

        if !isRefresh {
            carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items.map {$0.title}, toolBar: carbonToolbar, delegate: self)
            carbonTabSwipeNavigation?.insert(intoRootViewController: self, andTargetView: containerView)
            setupCarbonPages(carbonSwipeTabsItem: carbonTabSwipeNavigation!)

            //carbonTabSwipeNavigation?.pagesScrollView?.isScrollEnabled = false

            let widthOfTabIcons = (carbonToolbar.bounds.width)/2
            carbonTabSwipeNavigation?.carbonSegmentedControl!.setWidth(widthOfTabIcons, forSegmentAt: 0)
            carbonTabSwipeNavigation?.carbonSegmentedControl!.setWidth(widthOfTabIcons, forSegmentAt: 1)
            //carbonTabSwipeNavigation!.currentTabIndex = 1
        } else {
            setupCarbonPages(carbonSwipeTabsItem: carbonTabSwipeNavigation!)
            //carbonTabSwipeNavigation!.setIndicatorColor(nil)

            for cvc in carbonTabSwipeNavigation!.viewControllers.allValues {
                if let vc = cvc as? BaseViewController {
                    vc.configureView(isRefresh: true)
                }
            }
        }

    }

    func loadData() {
        self.showLoader()

        DataManager.shared.exportKeystore(assetId: assetId, pass: keystorePasswordString, password: passwordString) { [weak self] (exportKeystoreModels, error, errorString) in
            if error == nil {
                self?.exportKeystoreModels = exportKeystoreModels
                self?.hideLoaderSuccess()
            } else {
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Request Private Key failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Request Private Key failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Request Private Key failed", errorLabelMessage: "Unknown Error")
            }
        }
    }

    func showPasswordRequest() {

        if let sessionWords = SessionManager.shared.getWords() {
            passwordString = sessionWords
            loadData()
            return
        }

        enterPasswordView = R.nib.enterPasswordView.firstView(owner: nil)
        UIApplication.shared.keyWindow?.addSubview(enterPasswordView!)
        enterPasswordView?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        enterPasswordView?.delegate = self

        enterPasswordView?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.enterPasswordView?.alpha = 1
        }, completion: nil)
    }

}

extension ExportKeystoreViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {

        switch index {
        case 0:
            let vcStore = R.storyboard.exportKeystore.exportKeystoreStoreViewController()!
            vcStore.delegate = self
            exportKeystoreStoreViewController = vcStore
            return vcStore
        case 1:
            let vcQR = R.storyboard.exportKeystore.exportKeystoreQRViewController()!
            vcQR.delegate = self
            exportKeystoreQRViewController = vcQR
            vcQR.exportKeystoreModels = exportKeystoreModels
            return vcQR
        default:
            break
        }

        return UIViewController()
    }

    func setupCarbonPages(carbonSwipeTabsItem: CarbonTabSwipeNavigation) {

        carbonSwipeTabsItem.toolbar.isTranslucent = false
        carbonSwipeTabsItem.toolbar.backgroundColor = UIColor(componentType: .viewBackground)
        carbonSwipeTabsItem.setIndicatorColor(UIColor(componentType: .carbonText))
        carbonSwipeTabsItem.setSelectedColor(UIColor(componentType: .navigationItemTint), font: FontFamily.SFProText.semibold.font(size: 15))
        carbonSwipeTabsItem.setNormalColor(UIColor(componentType: .carbonText), font: FontFamily.SFProText.semibold.font(size: 15))
        carbonSwipeTabsItem.setIndicatorHeight(2)
        //carbonSwipeTabsItem.setTabExtraWidth(CGFloat(15))

    }
}

extension ExportKeystoreViewController: ExportKeystoreStoreViewControllerDelegate {
    func exportKeystoreStoreViewController(_ exportKeystoreStoreViewController: ExportKeystoreStoreViewController, didHeightChanged value: CGFloat) {
        self.contentHeightConstraint.constant = value
        self.scrollView.contentSize = CGSize(width: self.view.bounds.height, height: self.containerView.frame.origin.x + value)
    }
    func exportKeystoreStoreViewController(_ exportKeystoreStoreViewController: ExportKeystoreStoreViewController, didChangedPassword value: String) {
        keystorePasswordString = value
        showPasswordRequest()
    }
}

extension ExportKeystoreViewController: ExportKeystoreQRViewControllerDelegate {
    func exportKeystoreQRViewController(_ exportKeystoreQRViewController: ExportKeystoreQRViewController, didHeightChanged value: CGFloat) {
        self.contentHeightConstraint.constant = value
        self.scrollView.contentSize = CGSize(width: self.view.bounds.height, height: self.containerView.frame.origin.x + value)
    }
    func exportKeystoreQRViewController(_ exportKeystoreQRViewController: ExportKeystoreQRViewController, didChangedPassword value: String) {
        keystorePasswordString = value
        showPasswordRequest()
    }
}

extension ExportKeystoreViewController: EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String) {
        passwordString = password
        loadData()
    }
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView) {

    }
}
