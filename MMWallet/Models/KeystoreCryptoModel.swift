//
//  KeystoreCryptoModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 16.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class KeystoreCryptoModel: Object, Mappable {
    
    @objc dynamic var ciphertext = ""
    @objc dynamic var cipher = ""
    @objc dynamic var kdf = ""
    @objc dynamic var mac = ""
    @objc dynamic var cipherparams: KeystoreCipherparamsModel?
    @objc dynamic var kdfparams: KeystoreKdfparamsModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ciphertext <- map["ciphertext"]
        cipher <- map["cipher"]
        kdf <- map["kdf"]
        mac <- map["mac"]
        cipherparams <- map["cipherparams"]
        kdfparams <- map["kdfparams"]
    }
}
