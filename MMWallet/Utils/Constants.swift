//
//  Constants.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

class WalletConstants {
    
    // Services

    static let termsURL = "/legal/terms-and-policy.pdf"

    static let tokenImageURL = "https://raw.githubusercontent.com/TrustWallet/tokens/master/images/"

    static var linkedInRedirectURL: String {
        return ApiManager.shared.getServerUrl() + "/api/v2/users/auth/linkedin/callback"
    }

    static var weiboRedirectURL: String {
        return ApiManager.shared.getServerUrl() + "/api/v2/users/auth/weibo/callback"
    }
    
}
