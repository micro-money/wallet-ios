//
//  ButtonTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    var delegate: ButtonTableViewCellDelegate?

    static let kCellHeight: CGFloat = 60
    
    @IBOutlet weak var actionButton: UIButton! {
        didSet {
            actionButton.layer.cornerRadius = 5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    var isEnabledButton = false {
        didSet {
            actionButton.isEnabled = isEnabledButton
        }
    }
    
    func applyData(title: String) {
        actionButton.isEnabled = false
        actionButton.setTitle(title, for: .normal)

        selectionStyle = .none
        configureView()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.buttonTableViewCellAction(self)
    }
    
    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)

        actionButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        actionButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)
        actionButton.backgroundColor = Color(componentType: .buttonFill)
    }
}

protocol ButtonTableViewCellDelegate {
    func buttonTableViewCellAction(_ buttonTableViewCell: ButtonTableViewCell)
}
