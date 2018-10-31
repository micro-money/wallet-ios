//
//  TransactionDetailLoadingTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 23.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityView: UIActivityIndicatorView! {
        didSet {
            activityView.startAnimating()
        }
    }

    func getHeight() -> CGFloat {
        return 62
    }
}
