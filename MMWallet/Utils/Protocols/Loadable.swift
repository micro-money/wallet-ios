//
//  Loadable.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import PKHUD

protocol Loadable {
    func hideLoader()
    func showLoader()
    func hideLoaderSuccess(completion: (() -> ())?)
    func hideLoaderFailure(errorLabelTitle: String?, errorLabelMessage: String?, completion: (() -> ())?)
}

extension Loadable where Self: UIViewController {

    func hideLoader() {
        HUD.hide()
    }
    func showLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
    }
    func hideLoaderSuccess(completion: (() -> ())? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.endIgnoringInteractionEvents()
        HUD.flash(.success, onView: UIApplication.shared.keyWindow, delay: 1.0) { success in
            completion?()
        }
    }
    func hideLoaderFailure(errorLabelTitle: String? = nil, errorLabelMessage: String? = nil, completion: (() -> ())? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.endIgnoringInteractionEvents()
        if errorLabelTitle != nil || errorLabelMessage != nil  {
            HUD.flash(.labeledError(title: errorLabelTitle, subtitle: errorLabelMessage), onView: UIApplication.shared.keyWindow, delay: 3.0) { success in
                completion?()
            }
        } else {
            HUD.flash(.error, onView: UIApplication.shared.keyWindow, delay: 1.0) { success in
                completion?()
            }
        }
    }
}

protocol LoadableView {
    func hideLoader()
    func showLoader()
    func hideLoaderSuccess(completion: (() -> ())?)
    func hideLoaderFailure(errorLabelTitle: String?, errorLabelMessage: String?, completion: (() -> ())?)
}

extension LoadableView where Self: UIView {

    func hideLoader() {
        HUD.hide()
    }
    func showLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
    }
    func hideLoaderSuccess(completion: (() -> ())? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.endIgnoringInteractionEvents()
        HUD.flash(.success, onView: UIApplication.shared.keyWindow, delay: 1.0) { success in
            completion?()
        }
    }
    func hideLoaderFailure(errorLabelTitle: String? = nil, errorLabelMessage: String? = nil, completion: (() -> ())? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.endIgnoringInteractionEvents()
        if errorLabelTitle != nil || errorLabelMessage != nil  {
            HUD.flash(.labeledError(title: errorLabelTitle, subtitle: errorLabelMessage), onView: UIApplication.shared.keyWindow, delay: 3.0) { success in
                completion?()
            }
        } else {
            HUD.flash(.error, onView: UIApplication.shared.keyWindow, delay: 1.0) { success in
                completion?()
            }
        }
    }
}
