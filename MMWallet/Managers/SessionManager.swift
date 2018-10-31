//
//  SessionManager.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation
import RNCryptor

class SessionManager {
    
    static let shared = SessionManager()

    private var sessionPassword = ""

    private var sessionKey = ""
    private var sessionWords = ""

    private var isCleared = true
    
    private init() {
    }

    func start(words: String) {
        clear()

        sessionPassword = randomString(length: 16)
        sessionKey = try! generateEncryptionKey(withPassword: sessionPassword)
        sessionWords = try! encryptMessage(message: words, encryptionKey: sessionKey)
        isCleared = false
    }
    
    func clear() {

        sessionPassword = randomString(length: 32)
        sessionKey = randomString(length: 32)
        sessionWords = randomString(length: 32)
        isCleared = true
    }

    func getWords() -> String? {
        if isCleared {
            return nil
        }

        return try? decryptMessage(encryptedMessage: sessionWords, encryptionKey: sessionKey)
    }

    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }

    private func generateEncryptionKey(withPassword password:String) throws -> String {
        let randomData = RNCryptor.randomData(ofLength: 32)
        let cipherData = RNCryptor.encrypt(data: randomData, withPassword: password)
        return cipherData.base64EncodedString()
    }

    private func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }

    private func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {

        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!

        return decryptedString
    }
}
