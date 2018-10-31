//
//  KeystoreKdfparamsModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 16.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class KeystoreKdfparamsModel: Object, Mappable {
    
    @objc dynamic var dklen = 0
    @objc dynamic var salt = ""
    @objc dynamic var n = 0
    @objc dynamic var r = 0
    @objc dynamic var p = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        dklen <- map["dklen"]
        salt <- map["salt"]
        n <- map["n"]
        r <- map["r"]
        p <- map["p"]
    }
}
