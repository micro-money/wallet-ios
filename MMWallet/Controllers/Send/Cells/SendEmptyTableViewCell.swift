//
//  SendEmptyTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SendEmptyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        self.backgroundColor = UIColor(componentType: .viewBackground)
    }
}
