//
//  TokenInfoModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 19.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class TokenInfoModel: Object, Mappable {
    
    @objc dynamic var address = ""
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
    
    override class func primaryKey() -> String? {
        return "address"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        name <- map["name"]
        symbol <- map["symbol"]
    }
}
