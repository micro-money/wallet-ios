//
//  BaseTabBarController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 04.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum BaseTabBarSection: Int {
    case assets = 0
    case add = 1
    case qr = 2
    case settings = 3
}

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        NotificationCenter.default.addObserver(forName: .switchThemeNotificationName, object: nil, queue: nil) { [weak self] _ in
            self?.configureView(isRefresh: true)
        }
    }

    func configureView(isRefresh: Bool = false) {

        UITabBar.appearance().barTintColor = UIColor(componentType: .viewBackground)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor(componentType: .navigationItemTint)

        if isRefresh {
            self.tabBar.tintColor = UIColor(componentType: .navigationItemTint)
            self.tabBar.barTintColor = UIColor(componentType: .viewBackground)

            if self.viewControllers != nil {
                for vc in self.viewControllers! {
                    if let vc = vc as? BaseViewController {
                        vc.configureView(isRefresh: true)
                    }
                    if let nvc = vc as? BaseNavigationController {
                        nvc.configureView(isRefresh: true)
                    }
                }
            }
        }
    }

}
