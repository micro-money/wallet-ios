//
//  BaseTabBar.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 19.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class BaseTabBar: UITabBar {

    override var traitCollection: UITraitCollection {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return super.traitCollection
        }
        
        return UITraitCollection(horizontalSizeClass: .compact)
    }

}
