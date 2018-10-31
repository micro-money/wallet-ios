//
//  UserModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import RealmSwift
import ObjectMapper

class UserModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var displayName = ""
    @objc dynamic var familyName = ""
    @objc dynamic var givenName = ""
    @objc dynamic var gender = ""
    @objc dynamic var email = ""
    @objc dynamic var theme = ""
    @objc dynamic var language = ""
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil
    
    @objc dynamic var confirmed = false

    @objc dynamic var secret = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        displayName <- map["displayName"]
        familyName <- map["familyName"]
        givenName <- map["givenName"]
        gender <- map["gender"]
        email <- map["email"]
        theme <- map["theme"]
        language <- map["language"]
        createdAt <- (map["createdAt"], DateIntTransform())
        updatedAt <- (map["updatedAt"], DateIntTransform())
        confirmed <- map["confirmed"]

        secret <- map["secret"]
    }
}
