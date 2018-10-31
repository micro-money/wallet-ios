//
//  SettingsExportKeyViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum SettingsExportKeySections {
    case warning
    case input
    case copy
    case saveText
    case none
}

class SettingsExportKeyViewController: BaseViewController, Messageable, Loadable  {

    let sections: [SettingsExportKeySections] = [.warning, .input, .copy, .saveText]

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.settingsExportKeyWarningTableViewCell)
            tableView.register(R.nib.settingsExportKeyInputTableViewCell)
            tableView.register(R.nib.settingsExportKeyButtonTableViewCell)

            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor(componentType: .viewBackground)
        }
    }
    
    var assetId: Int = 0

    var passwordString = ""
    var enterPasswordView: EnterPasswordView?

    var inputTableViewCell: SettingsExportKeyInputTableViewCell?

    var copiedPopup: CopiedView?

    var exportKeyModel: ExportKeyModel? {
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
                self?.exportKeyModel = exportKeyModels?.first
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

        if let exportKeyModel = exportKeyModel {
            keyString = exportKeyModel.privateKey
        }

        UIPasteboard.general.string = keyString
        if copiedPopup == nil {
            copiedPopup = R.nib.copiedView.firstView(owner: nil)
            self.view.addSubview(copiedPopup!)
            copiedPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(inputTableViewCell!.inputTextView).offset(-10)
                make.centerX.equalTo(inputTableViewCell!.inputTextView)
                make.width.equalTo(136)
                make.height.equalTo(36)
            }
            copiedPopup!.alpha = 0

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

        if let exportKeyModel = exportKeyModel {
            let activityViewController = UIActivityViewController(activityItems: [exportKeyModel.privateKey as NSString], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})
        }
    }
}

extension SettingsExportKeyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.row] {
        case .warning:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyWarningTableViewCell.identifier, for: indexPath) as! SettingsExportKeyWarningTableViewCell
            cell.configureView()
            return cell
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyInputTableViewCell.identifier, for: indexPath) as! SettingsExportKeyInputTableViewCell
            cell.selectionStyle = .none
            cell.applyData(title: "settings.privatekey".localized(), placeholder: "")
            if let exportKeyModel = exportKeyModel {
                cell.applyData(title: "settings.privatekey".localized(), placeholder: exportKeyModel.privateKey)
            }
            inputTableViewCell = cell
            return cell
        case .copy:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyButtonTableViewCell.identifier, for: indexPath) as! SettingsExportKeyButtonTableViewCell
            cell.applyData(title: "settings.copykeys".localized().uppercased())
            cell.selectionStyle = .none
            cell.delegate = self
            cell.curSection = .copy
            return cell
        case .saveText:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyButtonTableViewCell.identifier, for: indexPath) as! SettingsExportKeyButtonTableViewCell
            cell.applyData(title: "settings.downloadastext".localized().uppercased(), isWhite: true)
            cell.selectionStyle = .none
            cell.delegate = self
            cell.curSection = .saveText
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
}

extension SettingsExportKeyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .copy:
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch sections[indexPath.row] {
        case .warning:
            return 137
        case .input:
            return 148
        default:
            break
        }
        return 65
    }
}

extension SettingsExportKeyViewController: EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String) {
        passwordString = password
        loadData()
    }
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView) {

    }
}

extension SettingsExportKeyViewController: SettingsExportKeyButtonTableViewCellDelegate {
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
