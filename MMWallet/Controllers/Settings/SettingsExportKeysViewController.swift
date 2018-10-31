//
//  SettingsExportKeysViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 26.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum SettingsExportKeysSections {
    case warning
    case keys
    case copy
    case saveText
    case empty
    case none
}

class SettingsExportKeysViewController: BaseViewController, Messageable, Loadable  {

    let sections: [SettingsExportKeysSections] = [.warning, .keys, .empty, .copy, .saveText]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.settingsExportKeyWarningTableViewCell)
            tableView.register(R.nib.settingsExportKeyTableViewCell)
            tableView.register(R.nib.settingsExportKeyButtonTableViewCell)
            tableView.register(R.nib.emptyTableViewCell)

            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }

    var assetId: Int = 0

    var passwordString = ""
    var enterPasswordView: EnterPasswordView?

    var copiedTableViewCell: SettingsExportKeyTableViewCell?
    var copiedButtonTableViewCell: SettingsExportKeyButtonTableViewCell?

    var copiedPopup: CopiedView?

    var exportKeyModels: [ExportKeyModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showPasswordRequest()
    }

    func applyData(assetId: Int) {
        self.assetId = assetId
    }

    override func configureView(isRefresh: Bool) {

        self.view.backgroundColor = UIColor(componentType: .viewBackground)

    }

    func loadData() {
        self.showLoader()

        DataManager.shared.exportPrivateKey(assetId: assetId, password: passwordString) { [weak self] (exportKeyModels, error, errorString) in
            if error == nil {
                self?.exportKeyModels = exportKeyModels
                self?.hideLoaderSuccess()
            } else {
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Request Private Key failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Request Private Key failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Request Private Key failed", errorLabelMessage: "Unknown Error")
            }
        }
    }

    func showPasswordRequest() {

        if let sessionWords = SessionManager.shared.getWords() {
            passwordString = sessionWords
            loadData()
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

    func showCopiedMessage() {
        var keyString = ""

        for exportKeyModel in exportKeyModels! {
            keyString += exportKeyModel.privateKey + " \n"
        }

        UIPasteboard.general.string = keyString
        if copiedPopup == nil {
            copiedPopup = R.nib.copiedView.firstView(owner: nil)
            self.view.addSubview(copiedPopup!)
            copiedPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(copiedButtonTableViewCell!).offset(-10)
                make.centerX.equalTo(copiedButtonTableViewCell!)
                make.width.equalTo(136)
                make.height.equalTo(36)
            }
            copiedPopup!.alpha = 0
            copiedPopup!.textLabel.text = "settings.privatekeypopup".localized()

            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.copiedPopup?.alpha = 1
            }, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.copiedPopup?.alpha = 0
                }) { [weak self] complete in
                    self?.copiedPopup?.removeFromSuperview()
                    self?.copiedPopup = nil
                }
            }
        }
    }

    func showCopiedCellMessage(indexCell: Int) {

        let keyString = exportKeyModels![indexCell].privateKey

        UIPasteboard.general.string = keyString
        if copiedPopup == nil {
            copiedPopup = R.nib.copiedView.firstView(owner: nil)
            self.view.addSubview(copiedPopup!)
            copiedPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(copiedTableViewCell!.titleLabel).offset(-30)
                make.centerX.equalTo(copiedTableViewCell!.titleLabel)
                make.width.equalTo(136)
                make.height.equalTo(36)
            }
            copiedPopup!.alpha = 0
            copiedPopup!.textLabel.text = "settings.privatekeypopup".localized()

            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.copiedPopup?.alpha = 1
            }, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.copiedPopup?.alpha = 0
                }) { [weak self] complete in
                    self?.copiedPopup?.removeFromSuperview()
                    self?.copiedPopup = nil
                }
            }
        }
    }

    func saveToText() {

        var keyString = ""

        for exportKeyModel in exportKeyModels! {
            keyString += exportKeyModel.privateKey + " \n"
        }

        let activityViewController = UIActivityViewController(activityItems: [keyString as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
}

extension SettingsExportKeysViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if exportKeyModels == nil {
            return 0
        }

        switch sections[section] {
        case .keys:
            return exportKeyModels!.count
        default:
            break
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.section] {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.emptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
            return cell
        case .warning:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyWarningTableViewCell.identifier, for: indexPath) as! SettingsExportKeyWarningTableViewCell
            cell.selectionStyle = .none
            return cell
        case .keys:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyTableViewCell.identifier, for: indexPath) as! SettingsExportKeyTableViewCell
            let model = exportKeyModels![indexPath.row]
            let asset = StorageManager.shared.getAsset(id: assetId)
            cell.applyData(title: model.address, balance: model.balance.cleanValue6 + " " + asset!.getCurrencySmallString())
            return cell
        case .copy:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyButtonTableViewCell.identifier, for: indexPath) as! SettingsExportKeyButtonTableViewCell
            cell.applyData(title: "settings.copykeys".localized().uppercased())
            cell.delegate = self
            cell.curSection = .copy
            copiedButtonTableViewCell = cell
            return cell
        case .saveText:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyButtonTableViewCell.identifier, for: indexPath) as! SettingsExportKeyButtonTableViewCell
            cell.applyData(title: "settings.downloadastext".localized().uppercased(), isWhite: true)
            cell.delegate = self
            cell.curSection = .saveText
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
}

extension SettingsExportKeysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .keys:
            copiedTableViewCell = tableView.cellForRow(at: indexPath) as? SettingsExportKeyTableViewCell
            showCopiedCellMessage(indexCell: indexPath.row)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch sections[indexPath.section] {
        case .warning:
            return 137
        case .keys:
            return 44
        case .empty:
            return 25
        default:
            break
        }
        return 65
    }
}

extension SettingsExportKeysViewController: EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String) {
        passwordString = password
        loadData()
    }
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView) {

    }
}

extension SettingsExportKeysViewController: SettingsExportKeyButtonTableViewCellDelegate {
    func settingsExportKeyButtonTableViewCellAction(_ settingsExportKeyButtonTableViewCell: SettingsExportKeyButtonTableViewCell) {
        switch settingsExportKeyButtonTableViewCell.curSection {
        case .copy:
            showCopiedMessage()
        case .saveText:
            saveToText()
        default:
            break
        }
    }
}
