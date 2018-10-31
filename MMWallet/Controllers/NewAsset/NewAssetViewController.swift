//
//  NewAssetViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class NewAssetViewController: BaseViewController {

    enum NewAssetSections {
        case title
        case fiat
        case crypto
        case token
    }

    let sections: [NewAssetSections] = [.title, .fiat, .crypto, .token]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.selectWithDescriptionTableViewCell)
            tableView.register(R.nib.titleTableViewCell)

            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIButton(type: .custom)
        backButton.titleLabel?.font = FontFamily.SFProText.regular.font(size: 17)
        backButton.setImage(R.image.backIcon(), for: .normal)
        backButton.setTitle("newassets.myassets".localized(), for: .normal)
        backButton.setTitleColor(UIColor(componentType: .navigationItemTint), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        //let attributedText = NSAttributedString(string: "newassets.myassets".localized(), attributes: [NSAttributedStringKey.font: FontFamily.SFProText.regular.font(size: 17)])
        //backButton.setAttributedTitle(attributedText, for: .normal)

        configureView(isRefresh: false)
    }

    override func configureView(isRefresh: Bool) {

        if isRefresh {
            tableView?.backgroundColor = UIColor(componentType: .viewBackground)
            tableView?.reloadData()
        }
    }

    @objc func backAction(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
}

extension NewAssetViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.titleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            cell.applyData(title: "newassets.addnew".localized())
            return cell
        case .crypto:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassets.addnewcryptocurrency".localized(), desc: "newassets.addnewcryptocurrencytext".localized())
            cell.isEnabledCell = true
            return cell
        case .fiat:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassets.addnewcurrency".localized(), desc: "newassets.addnewcurrencytext".localized())
            cell.isEnabledCell = false
            return cell
        case .token:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassets.addnewtoken".localized(), desc: "newassets.addnewtokentext".localized())
            cell.isEnabledCell = true
            return cell
        }

    }
}

extension NewAssetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .title:
            break
        case .crypto:
            break
        case .fiat:
            break
        case .token:
            navigateToNewAssetToken()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 78
        } else {
            return 76
        }
    }
}
