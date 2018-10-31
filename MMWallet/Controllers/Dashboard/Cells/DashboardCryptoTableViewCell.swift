//
//  DashboardCryptoTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class DashboardCryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var networkInfoView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var networkInfoLabel: UILabel!
    @IBOutlet weak var cryptoCurrencyLabel: UILabel!
    @IBOutlet weak var fiatLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

       configureView()
    }

    func configureView() {
        containerView.backgroundColor = UIColor(componentType: .textFieldBackground)
        lineView.backgroundColor = UIColor(componentType: .textFieldNormalLine)

        titleLabel.textColor = UIColor(componentType: .textSections)
        titleLabel.textColor = UIColor(componentType: .textSections)
        title2Label.textColor = UIColor(componentType: .textSections)

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.05
        //        containerView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
        containerView.layer.shadowPath = path.cgPath

        self.backgroundColor = UIColor(componentType: .viewBackground)
        backView.backgroundColor = UIColor(componentType: .viewBackground)
        networkInfoView.backgroundColor = UIColor(componentType: .textFieldBackground)

        fiatLabel.textColor = UIColor(componentType: .textFieldText)
        titleLabel.textColor = UIColor(componentType: .textFieldText)
        title2Label.textColor = UIColor(componentType: .textFieldText)

        cryptoLabel.textColor = UIColor(componentType: .labelPlaceholder)
        cryptoCurrencyLabel.textColor = UIColor(componentType: .labelPlaceholder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    var assetModel: AssetModel? {
        didSet {
            if let assetModel = assetModel {

                networkInfoLabel.text = "common.infonetwork".localized()

                titleLabel.text = assetModel.name
                title2Label.text = assetModel.name

                if assetModel.isNetworkAvailable {
                    networkInfoView.isHidden = true
                    fiatLabel.isHidden = false
                    cryptoLabel.isHidden = false
                    cryptoCurrencyLabel.isHidden = false
                } else {
                    networkInfoView.isHidden = false
                    fiatLabel.isHidden = true
                    cryptoLabel.isHidden = true
                    cryptoCurrencyLabel.isHidden = true
                }

                fiatLabel.text = "$ \(assetModel.rate!.USD.cleanValue)"
                if assetModel.balanceString.isEmpty {
                    cryptoLabel.text = "\(assetModel.balance.cleanValue6)"
                } else {
                    cryptoLabel.text = assetModel.balanceString
                }
                cryptoCurrencyLabel.text = assetModel.currency

                //iconImageView.image = assetModel.getAssetIcon()
                assetModel.setIconTo(imageView: iconImageView)
            }
        }
    }

}
