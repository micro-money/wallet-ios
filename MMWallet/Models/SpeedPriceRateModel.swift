//
//  SpeedPriceRateModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 31.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class SpeedPriceRateModel: Object, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var USD = 0.0
    @objc dynamic var ETH = 0.0
    @objc dynamic var BTC = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        USD <- map["USD"]
        ETH <- map["ETH"]
        BTC <- map["BTC"]
    }

    func getRate() -> Double {
        if ETH > 0.0 {
            return ETH
        }
        if BTC > 0.0 {
            return BTC
        }

        return 0.0
    }
}
