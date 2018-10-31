//
//  SelectCurrencyTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SelectCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var nextIconView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func applyData(title: String, iconName: String) {
        titleLabel.text = title
        if !iconName.isEmpty {
            currencyImageView.image = UIImage(named: iconName)
        }

        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        nextIconView.image = nextIconView.image?.withRenderingMode(.alwaysTemplate)
        nextIconView.tintColor = UIColor(componentType: .buttonNewAssetsNext)
        
        backView.backgroundColor = UIColor(componentType: .textFieldBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)

        selectionStyle = .none
    }

}
