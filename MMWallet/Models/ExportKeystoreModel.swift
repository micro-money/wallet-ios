//
//  ExportKeystoreModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 16.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ExportKeystoreModel: Object, Mappable {
    
    @objc dynamic var keystore: KeystoreModel?
    @objc dynamic var balance = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        keystore <- map["keystore"]
        balance <- map["balance"]
    }
}
