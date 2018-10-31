//
//  EmptyTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }

    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        selectionStyle = .none
    }

}
