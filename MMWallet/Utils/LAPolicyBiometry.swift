//
//  LAPolicyBiometry.swift
//  MMWallet
//
//  Created by Oleg Leizer on 25.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import Foundation
import LocalAuthentication

/// Хелпер для проверки доступности FaceID
///
/// - Returns: доступность FaceID на девайсе

enum FaceId {
    static var isSupported: Bool {
        let context = LAContext()
        var error: NSError?
        if #available(iOS 11.0, *) {
            _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            if context.biometryType == LABiometryType.faceID {
                return true
            }
        }
        return false
    }
}

enum TouchId {
    static var isSupported: Bool {
        let context = LAContext()
        var error: NSError?
        if #available(iOS 11.0, *) {
            _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            if context.biometryType == LABiometryType.touchID {
                return true
            }
        }
        return false
    }
}
