//
//  ErrorInputView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 03.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class ErrorInputView: UIView {

    @IBOutlet weak var textlabel: UILabel!
    
    func applyData(textString: String) {
        textlabel.text = textString
    }

}
