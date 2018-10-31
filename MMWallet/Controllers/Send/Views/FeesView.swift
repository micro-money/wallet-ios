//
//  FeesView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 31.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class FeesView: UIView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectCheckView: UIImageView!
    @IBOutlet weak var reportIconView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var spbLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backView.backgroundColor = UIColor(componentType: .viewBackground)
        levelLabel.textColor = UIColor(componentType: .navigationText)

        reportIconView.image = reportIconView.image?.withRenderingMode(.alwaysTemplate)
        reportIconView.tintColor = UIColor(componentType: .navigationText)
    }

    var isSelected = false {
        didSet {
            if isSelected {
                selectCheckView.isHidden = false
                selectView.isHidden = false
                levelLabel.textColor = UIColor(componentType: .feesSelected)
                timeLabel.textColor = UIColor(componentType: .feesSelected)
                spbLabel.textColor = UIColor(componentType: .feesSelected)
            } else {
                selectCheckView.isHidden = true
                selectView.isHidden = true
                levelLabel.textColor = UIColor(componentType: .feesTitle)
                timeLabel.textColor = UIColor(componentType: .feesText)
                spbLabel.textColor = UIColor(componentType: .feesText)
            }
        }
    }
}
