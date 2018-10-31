//
//  ConverterModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 01.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ConverterModel: Object, Mappable {
    
    @objc dynamic var id = ""
    
    @objc dynamic var from = ""
    @objc dynamic var to = ""
    
    @objc dynamic var USD = 0.0
    @objc dynamic var fromUSD = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        USD <- map["USD"]

        for key in map.JSON.keys {
            if key != "USD" {
                if let value = map.JSON[key] as? Double {
                    fromUSD = value
                }
            }
        }

    }

    func getRate(isUSD: Bool) -> Double {

        if isUSD {
            return USD
        }
        return fromUSD
    }
}
