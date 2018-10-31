//
//  SettingsExportKeyTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 26.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsExportKeyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        configureView()
    }
    
    func configureView() {
        lineView.backgroundColor = UIColor(componentType: .settingsLine)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        self.backgroundColor = UIColor(componentType: .subNavigationBackground)
    
    }
    
    var isEnabledCell = true {
        didSet{
            if isEnabledCell {
                self.backgroundColor = UIColor(componentType: .subNavigationBackground)
            } else {
                self.backgroundColor = UIColor(componentType: .viewBackground)
            }
        }
    }
    
    func applyData(title: String, balance: String) {
        titleLabel.text = title
        balanceLabel.text = balance
        
        configureView()
    }

}
