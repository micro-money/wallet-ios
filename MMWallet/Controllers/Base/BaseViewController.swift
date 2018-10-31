//
//  BaseViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
    }

    open func configureView(isRefresh: Bool) {
        
    }

    // MARK: - KeyboardNotifications
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var newHeight = keyboardSize.height
            if #available(iOS 11.0, *) {
                newHeight = keyboardSize.height - view.safeAreaInsets.bottom
            } else {
                newHeight = keyboardSize.height
            }
            keyboardHeightDidChange(with: newHeight, duration: duration, curve: curve)
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var newHeight = keyboardSize.height
            if #available(iOS 11.0, *) {
                newHeight = keyboardSize.height - view.safeAreaInsets.bottom
            } else {
                newHeight = keyboardSize.height
            }
            keyboardHeightDidChange(with: -newHeight, duration: duration, curve: curve)
        }
    }
    
    open func keyboardHeightDidChange(with keyboardHeight: CGFloat, duration: Double, curve: UInt) {
        
    }

}
