//
//  WalletModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import RealmSwift
import ObjectMapper

class WalletModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var balance = 0.0
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil
    
    @objc dynamic var mnemonic = false
    
    var assets = List<AssetModel>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        balance <- map["balance"]
        createdAt <- (map["createdAt"], DateIntTransform())
        updatedAt <- (map["updatedAt"], DateIntTransform())
        assets <- (map["assetList"], ListTransform<AssetModel>())
        mnemonic <- map["mnemonic"]
    }
}
