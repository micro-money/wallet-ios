//
//  SpeedPriceModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 31.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class SpeedPriceModel: Object, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var low: SpeedPriceRateModel?
    @objc dynamic var medium: SpeedPriceRateModel?
    @objc dynamic var high: SpeedPriceRateModel?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        low <- map["low"]
        medium <- map["medium"]
        high <- map["high"]
    }
}
