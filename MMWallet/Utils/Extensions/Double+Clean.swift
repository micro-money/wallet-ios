//
//  Double+Clean.swift
//  puntopago
//
//  Created by Dmitry Muravev on 09.06.2018.
//  Copyright © 2018 Cuberto. All rights reserved.
//

import Foundation

extension Double{
    var cleanValue: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)//
    }
    var cleanValue6: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        if self >= 1 {
            return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.6f", self)
        }
        return self.fractionDigits(min: 1, max: 6)
    }
}

extension Formatter {
    static let number = NumberFormatter()
}

extension FloatingPoint {
    func fractionDigits(min: Int = 2, max: Int = 2, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        Formatter.number.minimumFractionDigits = min
        Formatter.number.maximumFractionDigits = max
        Formatter.number.roundingMode = roundingMode
        Formatter.number.numberStyle = .decimal
        return Formatter.number.string(for: self) ?? ""
    }
}
