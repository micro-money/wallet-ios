//
//  NewAssetCryptoViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class NewAssetCryptoViewController: BaseViewController {

    enum NewAssetCryptoSections {
        case title
        case newAsset
        case importAsset
    }

    let sections: [NewAssetCryptoSections] = [.title, .newAsset, .importAsset]

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

    }

    override func configureView(isRefresh: Bool) {

        if isRefresh {
            tableView?.backgroundColor = UIColor(componentType: .viewBackground)
            tableView?.reloadData()
        }
    }

}

extension NewAssetCryptoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.titleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            cell.applyData(title: "newassetscrypto.addnew".localized())
            return cell
        case .newAsset:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassetscrypto.new".localized(), desc: "newassetscrypto.newtext".localized())
            return cell
        case .importAsset:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassetscrypto.import".localized(), desc: "newassetscrypto.importtext".localized())
            return cell
        }
    }
}

extension NewAssetCryptoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .title:
            break
        case .newAsset:
            navigateToNewAssetCryptoNew()
        case .importAsset:
            navigateToNewAssetCryptoNew(isImport: true)
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
