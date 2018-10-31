//
//  KeystoreCipherparamsModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 16.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class KeystoreCipherparamsModel: Object, Mappable {
    
    @objc dynamic var iv = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        iv <- map["iv"]
    }
}
