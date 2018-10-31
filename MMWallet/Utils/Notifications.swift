//
//  Notifications.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let resetRootControllerNotificationName = Notification.Name(rawValue: "ResetRootControllerNotification")
    static let resetRootToDashboardControllerNotificationName = Notification.Name(rawValue: "ResetRootToDashboardControllerNotificationName")
    static let resetRootToCreatePasscodeControllerNotificationName = Notification.Name(rawValue: "ResetRootToCreatePasscodeControllerNotificationName")
    static let switchThemeNotificationName = Notification.Name(rawValue: "SwitchThemeNotificationName")
    static let resetRootToSignInControllerNotificationName = Notification.Name(rawValue: "ResetRootToSignInControllerNotificationName")

    static let networkWeiboAuthorizeResponseNotificationName = Notification.Name(rawValue: "NetworkWeiboAuthorizeResponseNotificationName")
}
