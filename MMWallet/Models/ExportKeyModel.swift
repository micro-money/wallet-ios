//
//  ExportKeyModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ExportKeyModel: Object, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var address = ""
    @objc dynamic var privateKey = ""
    @objc dynamic var balance = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["address"]
        address <- map["address"]
        privateKey <- map["privateKey"]
        balance <- map["balance"]
    }
}
