//
//  SettingsExportSelectTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsExportSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor(componentType: .textFieldBackground)
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
            containerView.layer.shadowRadius = 2
            containerView.layer.shadowOpacity = 0.1
            //        containerView.layer.masksToBounds = false
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
            containerView.layer.shadowPath = path.cgPath
        }
    }
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {
        titleLabel.textColor = UIColor(componentType: .navigationText)

        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(componentType: .buttonNewAssetsNext)
    }

    var isEnabledCell = true {
        didSet{
            if isEnabledCell {
                containerView.backgroundColor = UIColor(componentType: .textFieldBackground)
            } else {
                containerView.backgroundColor = UIColor(componentType: .viewBackground)
            }
        }
    }

    func applyData(title: String) {
        titleLabel.text = title

        configureView()
    }
}
