//
//  UIRefreshControl+ProgramaticallyBeginRefresh.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 20.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
