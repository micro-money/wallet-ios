//
//  Int+Helpers.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

extension Int {
    mutating func increment() -> Int {
        self += 1
        return self
    }
    
    func convertToMinutes() -> (Int, Int) {
        return (self / 60, self % 60)
    }
}
