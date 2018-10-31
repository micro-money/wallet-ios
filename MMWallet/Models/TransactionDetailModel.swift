//
//  TransactionDetailModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 22.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class TransactionDetailModel: Object, Mappable {
    
    @objc dynamic var id = 0
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil

    @objc dynamic var hashString = ""
    @objc dynamic var blockHash = ""
    @objc dynamic var blockNumber = 0
    @objc dynamic var fromDirection: TransactionDirectionModel?
    @objc dynamic var toDirection: TransactionDirectionModel?

    @objc dynamic var gas = 0
    @objc dynamic var gasPrice = 0

    @objc dynamic var input = ""
    @objc dynamic var inputModel: TransactionInputModel?
    @objc dynamic var nonce = 0
    @objc dynamic var transactionIndex = 0
    @objc dynamic var valueString = ""
    @objc dynamic var v = ""
    @objc dynamic var r = ""
    @objc dynamic var s = ""
    
    @objc dynamic var descr = ""
    @objc dynamic var amount = 0.0
    @objc dynamic var status = ""
    @objc dynamic var currency = ""
    @objc dynamic var asset = 1
    @objc dynamic var rate: RateModel?
    @objc dynamic var direction = ""

    @objc dynamic var symbol = ""

    @objc dynamic var network = ""

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

        blockHash <- map["blockHash"]
        blockNumber <- map["blockNumber"]
        
        fromDirection <- map["from"]
        fromDirection?.id = "transactionDetail:from:\(id)"
        
        toDirection <- map["to"]
        toDirection?.id = "transactionDetail:to:\(id)"

        gas <- map["gas"]
        gasPrice <- map["gasPrice"]

        input <- map["input"]
        inputModel <- map["input"]
        if inputModel != nil {
            inputModel?.transactionId = id
            inputModel?.token?.id = "token:from:\(id)"
            inputModel?.tokenTo?.id = "token:to:\(id)"
        }
        nonce <- map["nonce"]
        transactionIndex <- map["transactionIndex"]
        valueString <- map["value"]
        v <- map["v"]
        r <- map["r"]
        s <- map["s"]
        
        descr <- map["descr"]
        amount <- map["amount"]
        status <- map["status"]
        currency <- map["currency"]
        asset <- map["asset"]
        
        rate <- map["rate"]
        rate?.id = "transactionDetail:\(id)"
        
        direction <- map["direction"]

        symbol <- map["symbol"]
        network <- map["network"]
    }
}
