//
//  CurrencyChartCollectionViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class CurrencyChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!

    var isSelectCell = false {
        didSet {
            if isSelectCell {
                currencyLabel.alpha = 1.0
                dataLabel.alpha = 1.0
            } else {
                currencyLabel.alpha = 0.48
                dataLabel.alpha = 0.48
            }
        }
    }
}
