//
//  NewAssetTokenSearchViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class NewAssetTokenSearchViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.selectCurrencyTableViewCell)
            tableView.register(R.nib.titleSearchTableViewCell)
            
            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }
    
    var searchActive = false
    var searchText = ""
    var searchRequestActive = false
    
    private var searchTimer: Timer?
    
    var tokensInfo: [TokenInfoModel]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView(isRefresh: false)
    }
    
    override func configureView(isRefresh: Bool) {
        
        if isRefresh {
            tableView?.backgroundColor = UIColor(componentType: .viewBackground)
            tableView?.reloadData()
        }
    }
    
    func startSearch() {
        if searchRequestActive {
            return
        }
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(findAction), userInfo: nil, repeats: false)
    }
    
    @objc func findAction() {
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        loadTokenInfoAction()
    }
    
    func loadTokenInfoAction() {
        if searchText.isEmpty {
            tokensInfo = nil
            return
        }
        
        searchRequestActive = true
        DataManager.shared.findTokenByAddress(address: self.searchText) { [weak self] (tokenInfoModels, error) in
            self?.tokensInfo = tokenInfoModels
            self?.searchRequestActive = false
        }
    }
    
}

extension NewAssetTokenSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tokensInfo == nil {
            return 1
        }
        return tokensInfo!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.titleSearchTableViewCell.identifier, for: indexPath) as! TitleSearchTableViewCell
            cell.applyData(title: "newassets.addnewtoken".localized())
            cell.searchBar.delegate = self
            if searchActive {
                cell.searchBar.text = searchText
                cell.searchBar.becomeFirstResponder()
            } else {
                cell.searchBar.text = ""
            }
            return cell
        }
        
        let model = tokensInfo![indexPath.row-1]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectCurrencyTableViewCell.identifier, for: indexPath) as! SelectCurrencyTableViewCell
        cell.applyData(title: model.name, iconName: "")
        return cell
    }
}

extension NewAssetTokenSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        let model = tokensInfo![indexPath.row-1]
        navigateToNewAssetImportToken(address: model.address)
        //navigateToImportAssetPrivateKey(currency: model.symbol, titleString: "\(model.symbol) Asset")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 126
        } else {
            return 44
        }
    }
}

extension NewAssetTokenSearchViewController: UISearchBarDelegate {
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
        searchActive = false;
        
        loadTokenInfoAction()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchActive = false
            tokensInfo = nil
        } else {
            searchActive = true
            startSearch()
        }
        
        self.searchText = searchText
        
        tableView.reloadData()
    }
}
