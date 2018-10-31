//
//  CurrencyRateModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class CurrencyRateModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var currency = ""
    @objc dynamic var USD = 0.0
    
    @objc dynamic var createdAt: Date? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        USD <- map["USD"]
        currency <- map["currency"]
        createdAt <- (map["createdAt"], DateIntTransform())
    }
}
