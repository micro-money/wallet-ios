//
//  NewAssetCryptoNewViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class NewAssetCryptoNewViewController: BaseViewController {

    enum NewAssetCryptoNewSections {
        case title
        case bitcoin
        case ethereum
    }

    var currencys: [String: NewAssetCryptoNewSections] = ["Bitcoin" : .bitcoin , "Ethereum": .ethereum]
    var sections: [NewAssetCryptoNewSections] = [.title, .bitcoin, .ethereum]
    var searchActive : Bool = false

    var isImport = false

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.selectCurrencyTableViewCell)
            tableView.register(R.nib.titleSearchTableViewCell)

            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    var titleSearchTableViewCell: TitleSearchTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func applyData(isImport: Bool) {
        self.isImport = isImport
    }

    override func configureView(isRefresh: Bool) {

        if isRefresh {
            tableView?.backgroundColor = UIColor(componentType: .viewBackground)
            tableView?.reloadData()
        }
    }

}

extension NewAssetCryptoNewViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.titleSearchTableViewCell.identifier, for: indexPath) as! TitleSearchTableViewCell
            if !isImport {
                cell.applyData(title: "newassetscrypto.addnew".localized())
            } else {
                cell.applyData(title: "newassetscrypto.importnew".localized())
            }
            titleSearchTableViewCell = cell
            if searchActive {
                cell.searchBar.becomeFirstResponder()
            }
            cell.searchBar.delegate = self
            return cell
        case .bitcoin:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectCurrencyTableViewCell.identifier, for: indexPath) as! SelectCurrencyTableViewCell
            cell.applyData(title: "Bitcoin", iconName: "bitcoinIcon")
            return cell
        case .ethereum:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectCurrencyTableViewCell.identifier, for: indexPath) as! SelectCurrencyTableViewCell
            cell.applyData(title: "Ethereum", iconName: "ethereumIcon")
            return cell
        }
    }
}

extension NewAssetCryptoNewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .title:
            break
        case .bitcoin:
            if !isImport {
                navigateToNewAssetCryptoName(currency: "BTC")
            } else {
                //navigateToNewAssetImportWallet(currency: "BTC")
            }
        case .ethereum:
            if !isImport {
                navigateToNewAssetCryptoName(currency: "ETH")
            } else {
                //navigateToNewAssetImportWallet(currency: "ETH")
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 126
        } else {
            return 44
        }
    }
}

extension NewAssetCryptoNewViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let filtered = currencys.filter({ (text, cur) -> Bool in
            let tmp:NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })

        searchActive = true

        sections = [.title]

        for filter in filtered {
            sections.append(filter.value)
        }

        if searchText.isEmpty {
            sections = [.title, .bitcoin, .ethereum]
            searchActive = false
        }

        tableView.reloadData()
    }
}
