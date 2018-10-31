//
//  NewAssetTokenViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 19.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class NewAssetTokenViewController: BaseViewController {

    enum NewAssetTokenSections {
        case title
        case importAsset
        case searchAsset
    }
    
    let sections: [NewAssetTokenSections] = [.title, .importAsset, .searchAsset]
    
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

extension NewAssetTokenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.titleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            cell.applyData(title: "newassetstoken.addnew".localized())
            return cell
        case .importAsset:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassetstoken.importnew".localized(), desc: "newassets.addnewtokentext".localized())
            return cell
        case .searchAsset:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectWithDescriptionTableViewCell.identifier, for: indexPath) as! SelectWithDescriptionTableViewCell
            cell.applyData(title: "newassetstoken.searchnew".localized(), desc: "newassets.addnewtokentext".localized())
            return cell
        }
    }
}

extension NewAssetTokenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .title:
            break
        case .importAsset:
            navigateToNewAssetImportToken(address: nil)
        case .searchAsset:
            navigateToSearchToken()
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
