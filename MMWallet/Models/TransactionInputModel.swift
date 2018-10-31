//
//  TransactionInputModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 08.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class TransactionInputModel: Object, Mappable {
    
    @objc dynamic var transactionId = 0
    @objc dynamic var data = ""
    
    @objc dynamic var tokenAmount = 0.0
    @objc dynamic var tokenRate: RateModel?
    @objc dynamic var token: TransactionDirectionModel?
    @objc dynamic var tokenTo: TransactionDirectionModel?
    
    override class func primaryKey() -> String? {
        return "transactionId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        tokenAmount <- map["tokenAmount"]
        tokenRate <- map["tokenRate"]
        token <- map["token"]
        tokenTo <- map["tokenTo"]
    }
}
