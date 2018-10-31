//
//  ImportTokenWatchViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class ImportTokenWatchViewController: BaseViewController, Messageable, Loadable {

    enum ImportWalletPrivateKeySections {
        case empty
        case name
        case address
        case empty2
        case button
    }

    let sections: [ImportWalletPrivateKeySections] = [.empty, .name, .address, .empty2, .button]

    var buttonTableViewCell: ButtonTableViewCell?

    var currencyString = ""
    var nameString = ""
    var addressString: String = "" {
        didSet {
            if Validator.isValidCurrencyAddress(currency: currencyString, address: addressString) {
                inputTableViewCellAddress?.validationState = .ok
            } else {
                inputTableViewCellAddress?.validationState = .error
            }
        }
    }

    var passwordString = ""
    var enterPasswordView: EnterPasswordView?

    var titleString: String?

    var textFieldEditingIndex = 1

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(R.nib.emptyTableViewCell)
            tableView.register(R.nib.inputTableViewCell)
            tableView.register(R.nib.inputBigTableViewCell)
            tableView.register(R.nib.buttonTableViewCell)

            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    var inputTableViewCellAddress: InputTableViewCell?

    func applyData(currency: String, titleString: String?, address: String?) {
        currencyString = currency
        self.titleString = titleString
        addressString = address ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override func configureView(isRefresh: Bool) {
        self.view.backgroundColor = UIColor(componentType: .viewBackground)

        if titleString != nil {
            self.navigationItem.title = titleString
        }

        if isRefresh {
            tableView?.backgroundColor = UIColor(componentType: .viewBackground)
            tableView?.reloadData()
        }
    }

    func createAction() {
        self.showLoader()

        let nameString = self.nameString
        let currencyString = self.currencyString
        let passwordString = self.passwordString
        let addressString = self.addressString

        DataManager.shared.findTokenByAddress(address: addressString) { [weak self] (tokenInfoModels, error) in
            if tokenInfoModels == nil || tokenInfoModels!.count != 1 {
                self?.hideLoaderFailure(errorLabelTitle: "Import Token failed", errorLabelMessage: "Unknown address of smart contract")
            } else {
                DataManager.shared.importTokenAsset(name: nameString, currency: currencyString, password: passwordString, key: nil, address: addressString) { [weak self] (assetModel, error, errorString) in
                    if error == nil {
                        self?.hideLoaderSuccess() {
                            BaseViewController.resetRootToDashboardController()
                        }
                    } else {
                        if let _errorString = errorString {
                            self?.hideLoaderFailure(errorLabelTitle: "Import Token failed", errorLabelMessage: _errorString)
                            return
                        } else if let _error = error {
                            self?.hideLoaderFailure(errorLabelTitle: "Import Token failed", errorLabelMessage: _error.getErrorString())
                            return
                        }
                        self?.hideLoaderFailure(errorLabelTitle: "Import Token failed", errorLabelMessage: "Unknown Error")
                    }
                }
            }
        }
    }

    func showPasswordRequest() {

        if let sessionWords = SessionManager.shared.getWords() {
            passwordString = sessionWords
            createAction()
            return
        }

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

    func updateButtonEnabling() {
        if !Validator.isValidCurrencyAddress(currency: currencyString, address: addressString) {
            buttonTableViewCell?.isEnabledButton = false
            return
        }
        if nameString.isEmpty || addressString.isEmpty {
            buttonTableViewCell?.isEnabledButton = false
        } else {
            buttonTableViewCell?.isEnabledButton = true
        }
    }

    override func keyboardHeightDidChange(with keyboardHeight: CGFloat, duration: Double, curve: UInt) {

        let newHeight = keyboardHeight < 0 ? 0 : keyboardHeight-44

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: { [weak self] in
            self?.bottomConstraint.constant = newHeight
            self?.view.layoutIfNeeded()
        }, completion: { (_) in
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: self.textFieldEditingIndex, section: 0), at: .bottom, animated: true)
            }
        })

    }
}

extension ImportTokenWatchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            return cell
        case .empty2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            return cell
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.inputTableViewCell.identifier, for: indexPath) as! InputTableViewCell
            cell.applyData(placeholder: "importwallet.assetname".localized(), value: nameString)
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.inputTableViewCell.identifier, for: indexPath) as! InputTableViewCell
            cell.applyData(placeholder: "newassetstoken.scaddress".localized(), value: addressString)
            cell.index = indexPath.row
            cell.delegate = self
            cell.inputTextField.keyboardType = .numbersAndPunctuation
            inputTableViewCellAddress = cell
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.buttonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            cell.applyData(title: "newassetstoken.import".localized().uppercased())
            buttonTableViewCell = cell
            return cell
        }
    }
}

extension ImportTokenWatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .empty:
            break
        case .empty2:
            break
        case .address:
            break
        case .name:
            break
        case .button:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.row] {
        case .empty:
            return 25
        case .empty2:
            return 30
        case .address:
            return InputTableViewCell.kCellHeight - 10
        case .name:
            return InputTableViewCell.kCellHeight - 10
        case .button:
            return ButtonTableViewCell.kCellHeight
        }
    }
}

extension ImportTokenWatchViewController: ButtonTableViewCellDelegate {
    func buttonTableViewCellAction(_ buttonTableViewCell: ButtonTableViewCell) {
        showPasswordRequest()
    }
}

extension ImportTokenWatchViewController: EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String) {
        passwordString = password
        createAction()
    }
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView) {

    }
}

extension ImportTokenWatchViewController: InputTableViewCellDelegate {
    func inputTableViewCell(_ inputTableViewCell: InputTableViewCell, didValueChanged value: String) {
        switch inputTableViewCell.index {
            case 1:
                nameString = value
            case 2:
                addressString = value
            default:
                break
        }
        updateButtonEnabling()
    }
    func inputTableViewCellAction(_ inputTableViewCell: InputTableViewCell) {
        if !nameString.isEmpty {
            showPasswordRequest()
        }
    }
    func inputTableViewCellDidBeginEditing(_ inputTableViewCell: InputTableViewCell) {
        textFieldEditingIndex = inputTableViewCell.index
    }
}
