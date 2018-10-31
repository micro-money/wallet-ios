//
//  Validator.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

struct Validator {
    static func hasValidSignUpCredentials(login: String, password: String) -> Bool {
        return isValidLogin(login) && isValidPassword(password)
    }
    
    static func invalidSignUpLoginReason(_ login: String) -> String? {
        if login.isEmpty {
            return "validator.loginrequired".localized()
        } else if !isValidLogin(login) {
            return "validator.logininvalid".localized()
        }
        return nil
    }
    
    static func invalidSignUpPasswordReason(_ password: String) -> String? {
        if password.isEmpty {
            return "validator.passwordrequired".localized()
        } else if !isValidPassword(password) {
            return "validator.passwordinvalid".localized()
        }
        return nil
    }
    
    static func hasValidLoginCredentials(login: String, password: String, confirmPassword: String? = nil) -> Bool {
        return isValidLogin(login) && isValidPassword(password) && isValidPassword(confirmPassword ?? "")
    }
    
    static func invalidLoginCredentialsReason(login: String, password: String) -> String? {
        if login.isEmpty {
            return "validator.loginrequired".localized()
        } else if !isValidLogin(login) {
            return "common.erroremail".localized()
        } else if password.isEmpty {
            return "validator.passwordrequired".localized()
        } else if !isValidPassword(password) {
            return "validator.passwordinvalid".localized()
        }
        return nil
    }
    
    static func isValidLogin(_ string: String) -> Bool {
        //        let usernameRegEx = "^[_-]|[\\w-]{2,}$"
        //        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        //        let result = usernameTest.evaluate(with: string)
        //        return result
        //return string.count >= 3

        return string.isValidEmail
    }
    
    static func isValidPassword(_ string: String) -> Bool {
        return string.count >= 8
    }

    static func isValidCurrencyAddress(currency: String, address: String) -> Bool {
        switch currency {
            case "ETH":
                return address.count == 42
            case "BTC":
                return address.count >= 27 && address.count <= 34
            default:
                break
        }
        //TODO: is token ?
        return address.count >= 27 && address.count <= 34
    }

    static func isValidPrivateKey(_ string: String) -> Bool {
        return string.count == 64
    }
}
