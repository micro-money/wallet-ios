//
//  ExportKeystoreStoreViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 12.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum ExportKeystoreStoreSections {
    case empty
    case text
    case pass
    case keystore
    case button
}

class ExportKeystoreStoreViewController: BaseViewController {

    var delegate: ExportKeystoreStoreViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.inputTableViewCell)
            tableView.register(R.nib.inputBigTableViewCell)
            tableView.register(R.nib.settingsExportKeyWarningTableViewCell)
            tableView.register(R.nib.emptyTableViewCell)
            tableView.register(R.nib.buttonTableViewCell)
            tableView.register(R.nib.settingsExportKeyTableViewCell)

            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    let sectionsEmpty: [ExportKeystoreStoreSections] = [.text, .pass, .empty, .button, .empty]
    let sectionsEmptyHeight: CGFloat = 299 + 85 + 25 + 60 + 25 //TODO: need refactoring

    var sections: [ExportKeystoreStoreSections] = [.text, .keystore, .empty]
    var sectionsHeight: CGFloat = 299 + 130 + 60 + 25 //TODO: need refactoring

    var passwordString = ""
    var keystoreString = ""

    var contentHeight:CGFloat = 0 {
        didSet {
            delegate?.exportKeystoreStoreViewController(self, didHeightChanged: contentHeight)
        }
    }

    var exportKeystoreModels: [ExportKeystoreModel]? {
        didSet {
            sectionsHeight = 299 + 130
            if let exportKeystoreModels = exportKeystoreModels {
                for _ in exportKeystoreModels {
                    sectionsHeight += 44
                }
            //    if let JSONString = keystoreModel.toJSONString(prettyPrint: false) as? String {
            //        let data = JSONString.data(using: .utf8)
            //        keystoreString = data!.hex
            //    }
            }
            sectionsHeight += 25
            tableView.reloadData()
        }
    }

    var buttonTableViewCell: ButtonTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        contentHeight = sectionsHeight

        configureView(isRefresh: false)
    }

    override func configureView(isRefresh: Bool) {

        tableView.backgroundColor = UIColor(componentType: .viewBackground)
    }

    func updateButtonStatus() {
        if exportKeystoreModels == nil {
            buttonTableViewCell?.isEnabledButton = !passwordString.isEmpty
        } else {
            buttonTableViewCell?.isEnabledButton = true
        }
    }

    func showKeystoreAction(index: Int) {
        if let model = exportKeystoreModels?[index] {
            let alertController = UIAlertController(title: model.keystore!.address, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "settings.copykeystore".localized(), style: .default) { [weak self] (action:UIAlertAction!) in
                self?.copyAction(index: index)
            })
            alertController.addAction(UIAlertAction(title: "settings.downloadaskstext".localized(), style: .default) { [weak self] (action:UIAlertAction!) in
                self?.saveAction(index: index)
            })
            let cancelAction = UIAlertAction(title: "common.actions.cancel".localized(), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func copyAction(index: Int) {
        if let model = exportKeystoreModels?[index].keystore {
            if let JSONString = model.toJSONString(prettyPrint: false) {
                UIPasteboard.general.string = JSONString
            }
        }
    }

    func saveAction(index: Int) {
        if let model = exportKeystoreModels?[index].keystore {
            if let JSONString = model.toJSONString(prettyPrint: false) {
                let activityViewController = UIActivityViewController(activityItems: [JSONString as NSString], applicationActivities: nil)
                present(activityViewController, animated: true, completion: {})
            }
        }
    }
}

extension ExportKeystoreStoreViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if exportKeystoreModels == nil {
            return sectionsEmpty.count
        }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if exportKeystoreModels == nil {
            return 1
        }

        switch sections[section] {
        case .keystore:
            return exportKeystoreModels!.count
        default:
            break
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let currentSection = exportKeystoreModels == nil ? sectionsEmpty[indexPath.section] : sections[indexPath.section]
        switch currentSection {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            cell.configureView()
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyWarningTableViewCell.identifier, for: indexPath) as! SettingsExportKeyWarningTableViewCell
            let attributedString = NSMutableAttributedString(string: "Store Offline\nPlease store the Keystore to a safe offline place like a USB drive. Never put it to Internet.\n\n", attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                .foregroundColor: UIColor(componentType: .navigationText),
                .kern: 0.0
            ])
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(location: 0, length: 13))
            let attributedString2 = NSMutableAttributedString(string: "Don’t Transfer via Internet Tools\nDon’t use Email/Cloud Storage/Notepad/IM tools to transfer Keystore. It easily gets hacked and result is loss.\n\n", attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                .foregroundColor: UIColor(componentType: .navigationText),
                .kern: 0.0
            ])
            attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(location: 0, length: 33))
            let attributedString3 = NSMutableAttributedString(string: "Store to Password Vault\nIf you like to store online please make sure some password vault apps, like 1Password/Keypass.", attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                .foregroundColor: UIColor(componentType: .navigationText),
                .kern: 0.0
            ])
            attributedString3.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(location: 0, length: 23))
            let combination = NSMutableAttributedString()
            combination.append(attributedString)
            combination.append(attributedString2)
            combination.append(attributedString3)
            cell.messageLabel.attributedText = combination
            cell.configureView()
            return cell
        case .pass:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.inputTableViewCell.identifier, for: indexPath) as! InputTableViewCell
            cell.applyData(placeholder: "common.password".localized(), value: passwordString)
            cell.index = indexPath.row
            cell.inputTextField.returnKeyType = .done
            cell.inputTextField.isSecureTextEntry = true
            cell.delegate = self
            return cell
        case .keystore:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyTableViewCell.identifier, for: indexPath) as! SettingsExportKeyTableViewCell
            let model = exportKeystoreModels![indexPath.row]
            cell.applyData(title: model.keystore!.address, balance: model.balance.cleanValue6 + " ETH")
            return cell
            //let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.inputBigTableViewCell.identifier, for: indexPath) as! InputBigTableViewCell
            //cell.applyData(title: "settings.keystore".localized(), placeholder: "", text: keystoreString)
            //cell.inputTextView.isScrollEnabled = true
            //return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.buttonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            buttonTableViewCell = cell
            updateButtonStatus()
            if exportKeystoreModels == nil {
                cell.applyData(title: "settings.exportkeystore".localized().uppercased())
            } else {
                cell.applyData(title: "settings.keystorebutton".localized().uppercased())
            }
            return cell
        }
    }
}

extension ExportKeystoreStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .keystore:
            showKeystoreAction(index: indexPath.row)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = exportKeystoreModels == nil ? sectionsEmpty[indexPath.section] : sections[indexPath.section]
        switch currentSection {
        case .empty:
            return 25
        case .text:
            return 299
        case .keystore:
            return 44
        case .pass:
            return 85
        case .button:
            return 60
        }
    }
}

extension ExportKeystoreStoreViewController: InputTableViewCellDelegate {
    func inputTableViewCell(_ inputTableViewCell: InputTableViewCell, didValueChanged value: String) {
        passwordString = value
        updateButtonStatus()
    }
    func inputTableViewCellAction(_ inputTableViewCell: InputTableViewCell) {
        inputTableViewCell.inputTextField.resignFirstResponder()
        delegate?.exportKeystoreStoreViewController(self, didChangedPassword: passwordString)
    }
    func inputTableViewCellDidBeginEditing(_ inputTableViewCell: InputTableViewCell) {

    }
}

extension ExportKeystoreStoreViewController: ButtonTableViewCellDelegate {
    func buttonTableViewCellAction(_ buttonTableViewCell: ButtonTableViewCell) {
        if exportKeystoreModels == nil {
            delegate?.exportKeystoreStoreViewController(self, didChangedPassword: passwordString)
        }
    }
}

protocol ExportKeystoreStoreViewControllerDelegate {
    func exportKeystoreStoreViewController(_ exportKeystoreStoreViewController: ExportKeystoreStoreViewController, didHeightChanged value: CGFloat)
    func exportKeystoreStoreViewController(_ exportKeystoreStoreViewController: ExportKeystoreStoreViewController, didChangedPassword value: String)
}
