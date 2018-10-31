//
//  ClearTextField.swift
//  Wallet
//
//  Created by Oleg Leizer on 08.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ClearTextField: SkyFloatingLabelTextField {

    var insetsRL: CGPoint?
    
    var validationState: ValidationState = .none {
        didSet {
            if validationState == .error {
                lineColor = Color(componentType: .textFieldErrorLine)
            } else {
                lineColor = Color(componentType: .textFieldNormalLine)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        var rect = bounds.shrink(up: 29).inset(topBottom: -10, sides: 15)
        if let leftView = leftView {
            rect = rect.shrink(right: leftView.frame.size.width + 6)
        }
        return rect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //if insetsRL != nil {
        //    var rect = bounds.shrink(left: insetsRL!.y).shrink(right: insetsRL!.x)
        //    return rect
        //}
        if text != nil && !text!.isEmpty {
            var rect = bounds.shrink(up: -17).inset(topBottom: -10, sides: 15)
            if insetsRL != nil {
                rect = rect.shrink(left: insetsRL!.y).shrink(right: insetsRL!.x)
            }
            return rect
        }
        return rectForBounds(bounds)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //if insetsRL != nil {
        //    var rect = bounds.shrink(left: insetsRL!.y).shrink(right: insetsRL!.x)
        //    return rect
        //}
        if text != nil && !text!.isEmpty {
            var rect = bounds.shrink(up: -17).inset(topBottom: -10, sides: 15)
            if insetsRL != nil {
                rect = rect.shrink(left: insetsRL!.y).shrink(right: insetsRL!.x)
            }
            return rect
        }
        return rectForBounds(bounds)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    func sharedSetup() {
        titleFormatter = { $0 }
        backgroundColor = UIColor(componentType: .textFieldBackground)
        tintColor = UIColor(componentType: .textFieldCaret)
        lineColor = Color(componentType: .textFieldNormalLine)
        lineHeight = 1

        selectedTitleColor = Color(componentType: .labelPlaceholder)
        selectedLineColor = Color(componentType: .textFieldNormalLine)

        //Text
        font = FontFamily.SFProText.regular.font(size: 16)
        textColor = Color(componentType: .textFieldText)

        titleFont = FontFamily.SFProText.regular.font(size: 12)
        titleColor = Color(componentType: .labelPlaceholder)

        //Placeholder
        placeholderFont = FontFamily.SFProText.regular.font(size: 16)
        placeholderColor = Color(componentType: .labelPlaceholder)
    }
    fileprivate func rectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds.shrink(left: 15).inset(topBottom: 10, sides: 15)
        if let leftView = leftView {
            rect = rect.shrink(right: leftView.frame.size.width + 6)
        }
        return rect
    }

}
