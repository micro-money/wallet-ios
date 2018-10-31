//
//  ContactDetailModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 13.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class ContactDetailModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var descr = ""
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil
    
    var address = List<ContactAddressModel>()
    var emails = List<ContactEmailModel>()
    var phones = List<ContactPhoneModel>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descr <- map["description"]
        
        createdAt <- (map["createdAt"], DateIntTransform())
        updatedAt <- (map["updatedAt"], DateIntTransform())
        
        address <- (map["addressList"], ListTransform<ContactAddressModel>())
        emails <- (map["emailList"], ListTransform<ContactEmailModel>())
        phones <- (map["phoneList"], ListTransform<ContactPhoneModel>())
    }
}
