//
//  SettingsAccessor.swift
//  Wallet
//
//  Created by Oleg Leizer on 17.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import Foundation

class SettingsAccessor {
    enum PinType: Int {
        case fourNumber
        case sixNumber
    }

    private let WalletFirstLaunchKey = "WalletFirstLaunch"
    private let WalletSettingsPinLength = "WalletSettingsPinLength"

    static var shared = SettingsAccessor()
    var isFirstLaunch: Bool {
        get { return !UserDefaults.standard.bool(forKey: WalletFirstLaunchKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: WalletFirstLaunchKey)
            UserDefaults.standard.synchronize()
        }
    }
    var pinType: PinType? {
        get { return SettingsAccessor.PinType(rawValue: UserDefaults.standard.integer(forKey: WalletSettingsPinLength)) }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: WalletSettingsPinLength)
            UserDefaults.standard.synchronize()
        }
    }
    var pinLength: Int? {
        get { return UserDefaults.standard.integer(forKey: WalletSettingsPinLength) }
        set {
            UserDefaults.standard.set(newValue, forKey: WalletSettingsPinLength)
            UserDefaults.standard.synchronize()
        }
    }
}
