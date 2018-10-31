//
//  TokenOwnerModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 27.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class TokenOwnerModel: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var address = ""
    @objc dynamic var balance = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
