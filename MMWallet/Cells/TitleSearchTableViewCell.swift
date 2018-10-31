//
//  TitleSearchTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TitleSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor(componentType: .navigationText)
            }
        }
    }
    
    func applyData(title: String) {
        titleLabel.text = title
        
        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)

        selectionStyle = .none
    }

}
