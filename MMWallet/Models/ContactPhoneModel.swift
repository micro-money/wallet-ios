//
//  ContactPhoneModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 13.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ContactPhoneModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var phone = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var id = self.id
            var phone = self.phone
            id <- map["id"]
            phone <- map["phone"]
        } else {
            id <- map["id"]
            phone <- map["phone"]
        }
    }
}
