//
//  HandyCategories.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

//remove object at index in array
extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element?) {
        if let object = object, let index = self.index(of: object) {
            remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object: object)
        }
    }
}

//get wordform of int
extension Int {
    
    func formatFrom(wordForms: [String]) -> String {
        guard wordForms.count == 3 else {
            return ""
        }
        
        let n = labs(self) % 100
        let n1 = labs(self) % 10
        if n > 10 && n < 20 {
            return wordForms[2]
        } else if n1 > 1 && n1 < 5 {
            return wordForms[1]
        } else if n1 == 1 {
            return wordForms[0]
        }
        return wordForms.last!
    }
}

//rounds the double to decimal places value
extension Double {
    
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//get topmost screen in app
extension UIApplication {
    
    class func topmostController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topmostController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topmostController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topmostController(base: presented)
        }
        return base
    }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}


extension Results {
    func toArray() -> [Element] {
        return Array(self)
    }
}

/*
extension Router: Equatable {
    
}

func == (lhs: Router, rhs: Router) -> Bool {
    switch (lhs, rhs) {
    case (.silentLogin(_), .silentLogin(_)):
        return true
    case (.login(_), .login(_)):
        return true
    case (.refreshToken(_), .refreshToken(_)):
        return true
    default:
        return false
    }
}
*/

extension String {
    func getPathExtension() -> String {
        return (self as NSString).pathExtension
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
