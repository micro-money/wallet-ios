//
//  ContactEmailModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 13.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ContactEmailModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var email = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var id = self.id
            var email = self.email
            id <- map["id"]
            email <- map["email"]
        } else {
            id <- map["id"]
            email <- map["email"]
        }
    }
}
