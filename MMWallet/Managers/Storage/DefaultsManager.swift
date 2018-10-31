//
//  DefaultsManager.swift
//
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let shared = DefaultsManager()
    let defaults = UserDefaults.standard
    
    private init() {}

    var isPinLogin: Bool? {
        get {
            return defaults.value(forKey: "IsPinLogin") as? Bool
        }
        set {
            defaults.set(newValue, forKey: "IsPinLogin")
        }
    }

    var isDarkTheme: Bool? {
        get {
            return defaults.value(forKey: "IsDarkTheme") as? Bool
        }
        set {
            defaults.set(newValue, forKey: "IsDarkTheme")
        }
    }

    var isBioLogin: Bool? {
        get {
            return defaults.value(forKey: "IsBioLogin") as? Bool
        }
        set {
            defaults.set(newValue, forKey: "IsBioLogin")
        }
    }

    var socialNetworkLoginType: String? {
        get {
            return defaults.value(forKey: "socialNetworkLoginType") as? String
        }
        set {
            defaults.set(newValue, forKey: "socialNetworkLoginType")
        }
    }

    
    func clean() {
        let appDomain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: appDomain)
    }
}
