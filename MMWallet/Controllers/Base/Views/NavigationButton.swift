//
//  NavigationButton.swift
//  Wallet
//
//  Created by Oleg Leizer on 13.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import Foundation

import UIKit

class NavigationButton: UIBarButtonItem {
    enum NavigationButtonType {
        case done
        case next
//        case edit
//        case cancel
        case backIcon
        case myAssets
    }

    var selector: Selector?
    var sender: AnyObject?
    var type: NavigationButtonType = .done {
        didSet {
            self.update()
        }
    }

    override init() {
        super.init()
        update()
    }

    convenience init(type: NavigationButtonType) {
        self.init()
        self.type = type
        update()
    }

    convenience init(type: NavigationButtonType, target: AnyObject?, action: Selector?) {
        self.init(type: type)
        self.selector = action
        self.sender = target
        update()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func update() {
        switch type {
        case .backIcon:
            image = R.image.backIcon()
            tintColor = UIColor(componentType: .navigationBarTint)
        case .done:
            title = "common.actions.done".localized()
            tintColor = UIColor(componentType: .navigationBarTint)
        case .next:
            title = "common.actions.next".localized()
            tintColor = UIColor(componentType: .navigationBarTint)
        case .myAssets:
            title = "newassets.myassets".localized()
            tintColor = UIColor(componentType: .navigationItemTint)
        }
        target = sender
        action = selector
    }
}
