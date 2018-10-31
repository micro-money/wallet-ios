//
//  HistoryCell.swift
//  MMWallet
//
//  Created by Oleg Leizer on 01.07.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    var delegate: HistoryCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.textColor = UIColor(componentType: .navigationText)
        lineView.backgroundColor = UIColor(componentType: .buttonCurrency)

        usdButton.setTitleColor(UIColor(componentType: .buttonCurrency), for: .normal)
        currencyButton.setTitleColor(UIColor(componentType: .buttonCurrency), for: .normal)
        usdButton.setTitleColor(UIColor(componentType: .buttonCurrencySelected), for: .selected)
        currencyButton.setTitleColor(UIColor(componentType: .buttonCurrencySelected), for: .selected)

        usdButton.isSelected = true
    }

    var curCurrency = "BTC" {
        didSet {
            currencyButton.setTitle(curCurrency, for: .normal)
            currencyButton.setTitle(curCurrency, for: .selected)
        }
    }
    
    @IBAction func usdAction(_ sender: Any) {
        usdButton.isSelected = true
        currencyButton.isSelected = false
        usdButton.titleLabel?.font = FontFamily.SFProText.semibold.font(size: 14)
        currencyButton.titleLabel?.font = FontFamily.SFProText.regular.font(size: 14)
        delegate?.historyCellDelegateShowUsd(self)

        usdButton.isSelected = true
        currencyButton.isSelected = false
    }

    @IBAction func currencyAction(_ sender: Any) {
        usdButton.isSelected = false
        currencyButton.isSelected = true
        currencyButton.titleLabel?.font = FontFamily.SFProText.semibold.font(size: 14)
        usdButton.titleLabel?.font = FontFamily.SFProText.regular.font(size: 14)
        delegate?.historyCellDelegateShowCurrency(self)

        usdButton.isSelected = false
        currencyButton.isSelected = true
    }
}

protocol HistoryCellDelegate {
    func historyCellDelegateShowUsd(_ historyCell: HistoryCell)
    func historyCellDelegateShowCurrency(_ historyCell: HistoryCell)
}
