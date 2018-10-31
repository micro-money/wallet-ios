//
//  MnemonicModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 16.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class MnemonicModel: Mappable {
    
    @objc dynamic var words = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        words <- map["mnemonic"]
    }
}
