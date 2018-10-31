//
//  TransactionModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 20.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class TransactionModel: Object, Mappable {
    
    @objc dynamic var id = 0
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil
    
    @objc dynamic var hashString = ""
    @objc dynamic var fromDirection: TransactionDirectionModel?
    @objc dynamic var toDirection: TransactionDirectionModel?
    
    @objc dynamic var descr = ""
    @objc dynamic var amount = 0.0
    @objc dynamic var status = ""
    @objc dynamic var currency = ""
    @objc dynamic var asset = 1
    @objc dynamic var rate: RateModel?
    @objc dynamic var direction = ""

    @objc dynamic var symbol = ""

    @objc dynamic var network = ""

    var tokenAmount = RealmOptional<Double>()
    @objc dynamic var tokenRate: RateModel?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    
        createdAt <- (map["createdAt"], DateIntTransform())
        updatedAt <- (map["updatedAt"], DateIntTransform())
        
        hashString <- map["hash"]
        
        fromDirection <- map["from"]
        fromDirection?.id = "transaction:from:\(id)"
        
        toDirection <- map["to"]
        toDirection?.id = "transaction:to:\(id)"
        
        descr <- map["descr"]
        amount <- map["amount"]
        status <- map["status"]
        currency <- map["currency"]
        asset <- map["asset"]
        
        rate <- map["rate"]
        rate?.id = "transaction:\(id)"
        
        direction <- map["direction"]

        symbol <- map["symbol"]

        tokenAmount.value <- map["tokenAmount"]
        tokenRate <- map["tokenRate"]
        tokenRate?.id = "transaction:tokenRate:\(id)"

        network <- map["network"]
    }
}
