//
//  LanguageManager.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

class LanguageManager {
    private static var defaultLocalizationCode: String = "en"
    
    static var appLocalizationCode: String = {
        let bundle = Bundle(for: WalletConstants.self)
        let localization = bundle.preferredLocalizations.first ?? defaultLocalizationCode
        let localizationCode = Locale.components(fromIdentifier: localization)["kCFLocaleLanguageCodeKey"] ?? defaultLocalizationCode
        return localizationCode
    }()
}
