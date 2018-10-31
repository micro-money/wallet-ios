//
//  Environment.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30/10/2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

public enum PlistKey {
    case ServerURL
    case KeychainID
    case TwitterConsumerKey
    case TwitterConsumerSecret
    case DemoLogin
    case WeiboAppKey
    case WeiboAppKeySecret
    case GoogleClientID
    case LinkedInKey
    case LinkedInSecret
    
    func value() -> String {
        switch self {
        case .ServerURL:
            return "SERVER_URL"
        case .KeychainID:
            return "KEYCHAIN_ID"
        case .TwitterConsumerKey:
            return "TWITTER_APP_ID"
        case .TwitterConsumerSecret:
            return "TWITTER_SECRET"
        case .DemoLogin:
            return "DEMO_LOGIN"
        case .WeiboAppKey:
            return "WEIBO_APP_ID"
        case .WeiboAppKeySecret:
            return "WEIBO_SECRET"
        case .GoogleClientID:
            return "GOOGLE_CLIENT_ID"
        case .LinkedInKey:
            return "LINKEDIN_KEY"
        case .LinkedInSecret:
            return "LINKEDIN_SECRET"
        }
    }
}
public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .ServerURL:
            return infoDict[PlistKey.ServerURL.value()] as! String
        case .KeychainID:
            return infoDict[PlistKey.KeychainID.value()] as! String
        case .TwitterConsumerKey:
            return infoDict[PlistKey.TwitterConsumerKey.value()] as! String
        case .TwitterConsumerSecret:
            return infoDict[PlistKey.TwitterConsumerSecret.value()] as! String
        case .DemoLogin:
            return infoDict[PlistKey.DemoLogin.value()] as! String
        case .WeiboAppKey:
            return infoDict[PlistKey.WeiboAppKey.value()] as! String
        case .WeiboAppKeySecret:
            return infoDict[PlistKey.WeiboAppKeySecret.value()] as! String
        case .GoogleClientID:
            return infoDict[PlistKey.GoogleClientID.value()] as! String
        case .LinkedInKey:
            return infoDict[PlistKey.LinkedInKey.value()] as! String
        case .LinkedInSecret:
            return infoDict[PlistKey.LinkedInSecret.value()] as! String
        }
    }
}
