//
//  AuthModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import RealmSwift
import ObjectMapper

class AuthModel: Object, Mappable {
    
    @objc dynamic var user: UserModel? = nil
    var token: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        token <- map["token"]
    }
    
}
