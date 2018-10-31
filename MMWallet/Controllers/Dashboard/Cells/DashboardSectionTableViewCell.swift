//
//  DashboardSectionTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class DashboardSectionTableViewCell: UITableViewCell {

    var delegate: DashboardSectionTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!

    var currentSection: DashboardSections = .crypto {
        didSet {
            configureView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        configureView()
    }

    func configureView() {
        titleLabel.textColor = Color(componentType: .labelDashboardSection)
        iconImageView.tintColor = Color(componentType: .labelDashboardSection)

        self.backgroundColor = UIColor(componentType: .viewBackground)

        if currentSection == .token {
            addButton.isHidden = false
            iconImageView.isHidden = false
        } else {
            addButton.isHidden = true
            iconImageView.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    @IBAction func addAction(_ sender: Any) {
        delegate?.dashboardSectionTableViewCellAction(self)
    }
}

protocol DashboardSectionTableViewCellDelegate {
    func dashboardSectionTableViewCellAction(_ dashboardSectionTableViewCell: DashboardSectionTableViewCell)
}
