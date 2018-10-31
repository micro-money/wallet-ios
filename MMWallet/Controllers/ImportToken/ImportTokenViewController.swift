//
//  ImportTokenViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//


import UIKit
import CarbonKit


class ImportTokenViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var currencyString = "ETH"
    var addressString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func applyData(address: String?) {
        addressString = address
    }

    override func configureView(isRefresh: Bool) {

        //titleLabel.text = "importwallet.title".lowercased().capitalizeFirstLetter()

        self.view.backgroundColor = UIColor(componentType: .viewBackground)

        titleLabel.textColor = UIColor(componentType: .navigationText)
        lineView.backgroundColor = UIColor(componentType: .carbonLine)

        if !isRefresh {
            addImportView()
        }
    }

    func addImportView() {

        let vcPK = R.storyboard.importToken.importTokenWatchViewController()!
        vcPK.applyData(currency: currencyString, titleString: nil, address: addressString)

        // fast simplification from CarbonKit
        self.addChild(vcPK)
        containerView.addSubview(vcPK.view)
        vcPK.view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.containerView)
        }
    }

}
