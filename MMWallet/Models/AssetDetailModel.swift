//
//  AssetDetailModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 20.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import RealmSwift
import ObjectMapper

class AssetDetailModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var currency = ""
    @objc dynamic var balanceString = ""
    @objc dynamic var balance = 0.0

    @objc dynamic var address = ""
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil
    
    @objc dynamic var rate: RateModel?

    @objc dynamic var typeString = "" //token cryptocurrency
    @objc dynamic var symbol = ""
    
    var transactionList = List<TransactionModel>()

    var owner = List<TokenOwnerModel>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        address <- map["address"]
        currency <- map["currency"]
        balance <- map["balance"]
        balanceString <- map["balance"]
        createdAt <- (map["createdAt"], DateIntTransform())
        updatedAt <- (map["updatedAt"], DateIntTransform())
        rate <- map["rate"]
        rate?.id = "asset:\(id)"

        typeString <- map["type"]
        symbol <- map["symbol"]

        if let owners: [String: Any] = map.JSON["owner"] as? [String: Any] {
            for address in owners.keys {
                let tokenOwnerModel = TokenOwnerModel()
                tokenOwnerModel.address = address
                if let ownerBalance: Double = owners[address] as? Double{
                    tokenOwnerModel.balance = ownerBalance
                }
                tokenOwnerModel.id = "\(id):\(address)"
                owner.append(tokenOwnerModel)
            }
        }
        
        transactionList <- (map["transactionList"], ListTransform<TransactionModel>())
    }
}
