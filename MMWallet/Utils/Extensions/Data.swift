//
//  Data.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 09.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

extension Data {
    var hex: String {
        return map{String(format: "%02hhx", $0)}.joined()
    }
    
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    var hexEncoded: String {
        return "0x" + self.hex
    }
}
