//
//  SelectWithDescriptionTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SelectWithDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nextIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        backView.backgroundColor = UIColor(componentType: .textFieldBackground)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        backView.layer.shadowRadius = 2
        backView.layer.shadowOpacity = 0.1
        //        containerView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
        backView.layer.shadowPath = path.cgPath
        
        nextIconView.image = nextIconView.image?.withRenderingMode(.alwaysTemplate)
        nextIconView.tintColor = UIColor(componentType: .buttonNewAssetsNext)
        
        titleLabel.textColor = UIColor(componentType: .navigationText)
        descLabel.textColor = UIColor(componentType: .textSections)
    }
    
    var isEnabledCell = true {
        didSet{
            if isEnabledCell {
                backView.backgroundColor = UIColor(componentType: .textFieldBackground)
            } else {
                backView.backgroundColor = UIColor(componentType: .viewBackground)
            }
        }
    }
    
    func applyData(title: String, desc: String) {
        titleLabel.text = title
        descLabel.text = desc

        selectionStyle = .none
        configureView()
    }

}
