//
//  ContactAddressModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 13.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ContactAddressModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var address = ""
    @objc dynamic var currency: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {

        if map.mappingType == .toJSON {
            var id = self.id
            var address = self.address
            var currency = self.currency
            id <- map["id"]
            address <- map["address"]
            currency <- map["currency"]
        } else {
            id <- map["id"]
            address <- map["address"]
            currency <- map["currency"]
        }
    }
}
