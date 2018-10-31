//
//  TitleTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)
    }
    
    func applyData(title: String) {
        titleLabel.text = title

        selectionStyle = .none
        configureView()
    }

}
