//
//  UIViewExtensions.swift
//  Wallet
//
//  Created by Oleg Leizer on 13.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit

extension UIView {

    var isVisible: Bool {
        get { return !isHidden }
        set { isHidden = !newValue}
    }
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func addDashedLineBorder() {
        let color = Color(hexString: "979797").cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = (self.frame.size)
        let shapeRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color

        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}
