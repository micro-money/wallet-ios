//
//  TransactionDetailInputTextField.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 27.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailInputTextField: UITextField {

    let padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
