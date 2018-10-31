//
//  TouchIdViewController.swift
//  Wallet
//
//  Created by Oleg Leizer on 15.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit

class TouchIdViewController: BaseViewController {

    @IBOutlet weak var dontButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override func configureView(isRefresh: Bool) {
        title = "setuppin.usetouchid".localized()
        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "setuppin.usetouchidtext".localized()

        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            lineView.alpha = 0.3
            dontButton.alpha = 0.3
        }
    }

    @IBAction func useButtonTouched(_ sender: Any) {
        DefaultsManager.shared.isBioLogin = true
        BaseViewController.resetRootToDashboardController()
    }
    
    @IBAction func skipButtonTouched(_ sender: Any) {
        DefaultsManager.shared.isBioLogin = nil
        BaseViewController.resetRootToDashboardController()
    }
}
