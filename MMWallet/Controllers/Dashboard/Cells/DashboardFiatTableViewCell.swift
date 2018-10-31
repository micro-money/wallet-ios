//
//  DashboardFiatTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class DashboardFiatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var currencyLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        configureView()
    }

    func configureView() {
        containerView.backgroundColor = UIColor(componentType: .textFieldBackground)

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.05
        //        containerView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
        containerView.layer.shadowPath = path.cgPath

        self.backgroundColor = UIColor(componentType: .viewBackground)
        backView.backgroundColor = UIColor(componentType: .viewBackground)

        countLabel.textColor = UIColor(componentType: .textFieldText)
        currencyLabel.textColor = UIColor(componentType: .textFieldText)
    }

    var assetModel: AssetModel? {
        didSet {
            if let assetModel = assetModel {
                if assetModel.balanceString.isEmpty {
                    countLabel.text = "\(assetModel.balance.cleanValue) \(assetModel.symbol)"
                } else {
                    countLabel.text = assetModel.balanceString + " " + assetModel.symbol
                }
                currencyLabel.text = assetModel.name

                assetModel.setIconTo(imageView: logoImageView)
            }
        }
    }
}
