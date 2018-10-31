//
//  BaseNavigationController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 04.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        NotificationCenter.default.addObserver(forName: .switchThemeNotificationName, object: nil, queue: nil) { [weak self] _ in
            self?.configureView()
        }
    }

    func configureView(isRefresh:Bool = false) {
        UINavigationBar.appearance().barTintColor = UIColor(componentType: .navigationBackground)
        UINavigationBar.appearance().isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(componentType: .navigationText)]
        UINavigationBar.appearance().titleTextAttributes = textAttributes

        if isRefresh {
            for vc in self.viewControllers {
                if let vc = vc as? BaseViewController {
                    vc.configureView(isRefresh: true)
                }
                if let nvc = vc as? BaseNavigationController {
                    nvc.configureView(isRefresh: true)
                }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            return .lightContent
        }
        return .default
    }
}
