//
//  KeystoreModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 16.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class KeystoreModel: Object, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var version = 0
    @objc dynamic var address = ""
    @objc dynamic var crypto: KeystoreCryptoModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["address"]
        version <- map["version"]
        address <- map["address"]
        crypto <- map["crypto"]
    }
}
