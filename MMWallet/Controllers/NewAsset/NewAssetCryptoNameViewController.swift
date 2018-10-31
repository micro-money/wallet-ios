//
//  NewAssetCryptoNameViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class NewAssetCryptoNameViewController: BaseViewController, Messageable, Loadable {

    enum NewAssetCryptoNameSections {
        case empty1
        case input
        case empty2
        case button
    }

    let sections: [NewAssetCryptoNameSections] = [.empty1, .input, .empty2, .button]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.inputTableViewCell)
            tableView.register(R.nib.emptyTableViewCell)
            tableView.register(R.nib.buttonTableViewCell)

            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    var currencyString = ""
    var nameString = ""
    var passwordString = ""

    var enterPasswordView: EnterPasswordView?
    var buttonTableViewCell: ButtonTableViewCell?
    var inputTableViewCell: InputTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    func applyData(currency: String) {
        currencyString = currency
    }

    override func configureView(isRefresh: Bool) {

        switch currencyString {
            case "BTC":
                self.navigationItem.title = "Bitcoin Asset"
            case "ETH":
                self.navigationItem.title = "Ethereum Asset"
            default:
                self.navigationItem.title = "\(currencyString) Asset"
        }

        if isRefresh {
            tableView?.backgroundColor = UIColor(componentType: .viewBackground)
            tableView?.reloadData()
        }
    }

    func createAsset() {

        self.showLoader()
        DataManager.shared.createAsset(name: nameString, currency: currencyString, password: passwordString) { [weak self] (assetModel, error, errorString) in
            if error == nil {
                self?.hideLoaderSuccess() {
                    BaseViewController.resetRootToDashboardController()
                }
            } else {
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Creation Asset failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Creation Asset failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Creation Asset failed", errorLabelMessage: "Unknown Error")
            }
        }
    }

    func showPasswordRequest() {

        if let sessionWords = SessionManager.shared.getWords() {
            passwordString = sessionWords
            createAsset()
            return
        }

        inputTableViewCell?.inputTextField.resignFirstResponder()

        enterPasswordView = R.nib.enterPasswordView.firstView(owner: nil)
        UIApplication.shared.keyWindow?.addSubview(enterPasswordView!)
        enterPasswordView?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        enterPasswordView?.delegate = self

        enterPasswordView?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.enterPasswordView?.alpha = 1
        }, completion: nil)
    }
}

extension NewAssetCryptoNameViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.inputTableViewCell.identifier, for: indexPath) as! InputTableViewCell
            cell.delegate = self
            cell.applyData(placeholder: "importwallet.assetname".localized(), value: nameString)
            inputTableViewCell = cell
            return cell
        case .empty1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            cell.configureView()
            return cell
        case .empty2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            cell.configureView()
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.buttonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            cell.applyData(title: "newassets.buttoncreate".localized().uppercased())
            buttonTableViewCell = cell
            return cell
        }
    }
}

extension NewAssetCryptoNameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .input:
            break
        case .button:
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.row] {
        case .empty1:
            return 12
        case .input:
            return 110
        case .empty2:
            return 28
        case .button:
            return 60
        }
    }
}

extension NewAssetCryptoNameViewController: ButtonTableViewCellDelegate {
    func buttonTableViewCellAction(_ buttonTableViewCell: ButtonTableViewCell) {
        if !nameString.isEmpty {
            showPasswordRequest()
        }
    }
}

extension NewAssetCryptoNameViewController: InputTableViewCellDelegate {
    func inputTableViewCell(_ inputTableViewCell: InputTableViewCell, didValueChanged value: String) {
        nameString = value
        buttonTableViewCell?.isEnabledButton = !value.isEmpty
    }
    func inputTableViewCellAction(_ inputTableViewCell: InputTableViewCell) {
        if !nameString.isEmpty {
            showPasswordRequest()
        }
    }
    func inputTableViewCellDidBeginEditing(_ inputTableViewCell: InputTableViewCell) {

    }
}

extension NewAssetCryptoNameViewController: EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String) {
        passwordString = password
        createAsset()
    }
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView) {

    }
}
