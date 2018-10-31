//
//  CGRectExtensions.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

import CoreGraphics
import UIKit
import Foundation

extension CGRect {
    
    // MARK: - helpers
    // swiftlint:disable identifier_name
    var x: CGFloat {
        return self.origin.x
    }
    // swiftlint:disable identifier_name
    var y: CGFloat {
        return self.origin.y
    }
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    // MARK: - inset(xxx:)
    func inset(all: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: all, left: all, bottom: all, right: all))
    }
    
    func inset(topBottom: CGFloat, sides: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: topBottom, left: sides, bottom: topBottom, right: sides))
    }
    
    func inset(topBottom: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: topBottom, left: 0, bottom: topBottom, right: 0))
    }
    
    func inset(sides: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: 0, left: sides, bottom: 0, right: sides))
    }
    
    func inset(top: CGFloat, sides: CGFloat, bottom: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: top, left: sides, bottom: bottom, right: sides))
    }
    
    func inset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    func inset(_ insets: UIEdgeInsets) -> CGRect {
        return self.inset(by: insets)
    }
    
    // MARK: - shrink(xxx:)
    func shrink(left amt: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: amt))
    }
    
    func shrink(right amt: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: 0, left: amt, bottom: 0, right: 0))
    }
    
    func shrink(down amt: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: amt, left: 0, bottom: 0, right: 0))
    }
    
    func shrink(up amt: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: amt, right: 0))
    }
}
