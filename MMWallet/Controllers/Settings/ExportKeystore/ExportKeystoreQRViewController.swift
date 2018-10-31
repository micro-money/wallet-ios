//
//  ExportKeystoreQRViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 12.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum ExportKeystoreQRSections {
    case empty
    case empty2
    case text
    case button
}

class ExportKeystoreQRViewController: BaseViewController {

    var delegate: ExportKeystoreQRViewControllerDelegate?

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
            delegate?.exportKeystoreQRViewController(self, didHeightChanged: contentHeight)
        }
    }

    var buttonTableViewCell: ButtonTableViewCell?

    var exportKeystoreModels: [ExportKeystoreModel]? {
        didSet {
            sectionsHeight = 299 + 130
            if let exportKeystoreModels = exportKeystoreModels {
                for _ in exportKeystoreModels {
                    sectionsHeight += 44
                }
            }
            sectionsHeight += 25
            tableView?.reloadData()
        }
    }

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

    func showQRAction(index: Int) {

        if let model = exportKeystoreModels?[index].keystore {
            if let JSONString = model.toJSONString(prettyPrint: false) {
                let qrView = R.nib.qrView.firstView(owner: nil)
                UIApplication.shared.keyWindow?.addSubview(qrView!)
                qrView!.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(0)
                    make.left.equalTo(0)
                    make.width.equalTo(UIScreen.main.bounds.width)
                    make.height.equalTo(UIScreen.main.bounds.height)
                }

                qrView!.hashString = JSONString
            }
        }
    }
}

extension ExportKeystoreQRViewController: UITableViewDataSource {

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
            let attributedString = NSMutableAttributedString(string: "Only for Transport Wallet\nForbidden to save/screenshot/take photos of the QR code. It’s convenience to transport wallet to your other devices.\n\n", attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                .foregroundColor: UIColor(componentType: .navigationText),
                .kern: 0.0
            ])
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(location: 0, length: 25))
            let attributedString2 = NSMutableAttributedString(string: "Using in Safe Environment\nPlease make sure nobody and no camera around when using. It may cause irreversible loss if somebody catch it.", attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                .foregroundColor: UIColor(componentType: .navigationText),
                .kern: 0.0
            ])
            attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(location: 0, length: 25))
            let combination = NSMutableAttributedString()
            combination.append(attributedString)
            combination.append(attributedString2)

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

extension ExportKeystoreQRViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .keystore:
            showQRAction(index: indexPath.row)
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
            return 255
        case .button:
            return 60
        case .keystore:
            return 44
        case .pass:
            return 85
        }
    }
}

extension ExportKeystoreQRViewController: InputTableViewCellDelegate {
    func inputTableViewCell(_ inputTableViewCell: InputTableViewCell, didValueChanged value: String) {
        passwordString = value
        updateButtonStatus()
    }
    func inputTableViewCellAction(_ inputTableViewCell: InputTableViewCell) {
        inputTableViewCell.inputTextField.resignFirstResponder()
        delegate?.exportKeystoreQRViewController(self, didChangedPassword: passwordString)
    }
    func inputTableViewCellDidBeginEditing(_ inputTableViewCell: InputTableViewCell) {

    }
}

extension ExportKeystoreQRViewController: ButtonTableViewCellDelegate {
    func buttonTableViewCellAction(_ buttonTableViewCell: ButtonTableViewCell) {
        if exportKeystoreModels == nil {
            delegate?.exportKeystoreQRViewController(self, didChangedPassword: passwordString)
        }
    }
}

protocol ExportKeystoreQRViewControllerDelegate {
    func exportKeystoreQRViewController(_ exportKeystoreQRViewController: ExportKeystoreQRViewController, didHeightChanged value: CGFloat)
    func exportKeystoreQRViewController(_ exportKeystoreQRViewController: ExportKeystoreQRViewController, didChangedPassword value: String)
}
