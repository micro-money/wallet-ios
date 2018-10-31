//
//  TransactionDirectionModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 20.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class TransactionDirectionModel: Object, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var hashString = ""
    @objc dynamic var name = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        hashString <- map["hash"]
        name <- map["name"]
    }
}
