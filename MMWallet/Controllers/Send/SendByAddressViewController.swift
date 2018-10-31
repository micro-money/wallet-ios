//
//  SendByAddressViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

enum SendByAddressSections {
    case empty
    case address
    case crypto
    case usd
    case empty2
    case fees
    case button
    case empty3
    case none
}

class SendByAddressViewController: BaseViewController, Messageable, Loadable {

    var delegate: SendByAddressViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.sendInputTableViewCell)
            tableView.register(R.nib.sendEmptyTableViewCell)
            tableView.register(R.nib.sendFeesTableViewCell)
            tableView.register(R.nib.sendButtonTableViewCell)

            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    let sections: [SendByAddressSections] = [.empty, .address, .crypto, .usd, .empty2, .fees, .button, .empty3]
    let sectionsHeight: CGFloat = 25 + 70 + 70 + 70 + 10 + 229 + 100 + 25 //TODO: need refactoring

    var currencyString = ""
    var addressString = "" {
        didSet {
            if Validator.isValidCurrencyAddress(currency: currencyString, address: addressString) {
                sendInputTableViewCellAddress?.validationState = .ok
            } else {
                sendInputTableViewCellAddress?.validationState = .error
            }
        }
    }
    var valueString = ""
    var valueUsdString = ""
    var feesString = "low"
    var assetId = 0

    var assetAddressString = ""

    var passwordString = ""
    var enterPasswordView: EnterPasswordView?

    var sendButtonTableViewCell: SendButtonTableViewCell?
    var sendInputTableViewCellCrypto: SendInputTableViewCell?
    var sendInputTableViewCellUSD: SendInputTableViewCell?
    var sendInputTableViewCellAddress: SendInputTableViewCell?

    var sendFeesTableViewCell: SendFeesTableViewCell?

    var converterModel: ConverterModel? {
        didSet {
            tableView?.reloadData()
        }
    }

    var speedPriceModel: SpeedPriceModel? {
        didSet {
            sendFeesTableViewCell?.speedPriceModel = speedPriceModel
            //tableView?.reloadData()
        }
    }

    var contentHeight:CGFloat = 0 {
        didSet {
            delegate?.sendByAddressViewController(self, didHeightChanged: contentHeight)
        }
    }

    private var updateFeesTimer: Timer?
    var feesRequestActive = false

    private var convertorTimer: Timer?
    var convertorToUSD = false

    var isStartedSendAction = false

    func applyData(currency: String, assetId: Int, address: String? = nil) {
        currencyString = currency
        self.assetId = assetId

        if let asset = StorageManager.shared.getAsset(id: assetId) {
            assetAddressString = asset.address
        }

        if address != nil {
            addressString = address!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentHeight = sectionsHeight

        loadData()
    }

    func loadData() {

        //DataManager.shared.getSpeedPrice(currency: currencyString) { [weak self] (speedPriceModel, error) in
        //    if speedPriceModel != nil {
        //        self?.speedPriceModel = speedPriceModel
        //    }
        //}

        loadFeesAction()

        DataManager.shared.getConverter(from: currencyString, to: "USD", amount: 1.0) { [weak self] (converterModel, error) in
            if converterModel != nil {
                self?.converterModel = converterModel
            }
        }
    }

    func sendMoney() {

        isStartedSendAction = true

        if passwordString.isEmpty {
            showPasswordRequest()
            return
        }

        showLoader()
        DataManager.shared.sendMoney(assetId: assetId, address: addressString, speed: feesString, password: passwordString, value: valueString) { [weak self] (transactionModel, error, errorString) in
            if error == nil {
                self?.hideLoaderSuccess() {
                    self?.isStartedSendAction = false
                    self?.sendButtonTableViewCell?.setSuccesIcon()
                    DataManager.shared.isNeedReloadWallet = true
                    DataManager.shared.isNeedReloadAssets = true
                    DispatchQueue.main.async { [weak self] in
                        self?.navigateToBack()
                    }
                }
            } else {
                self?.isStartedSendAction = false
                self?.sendButtonTableViewCell?.reset()
                if let _errorString = errorString {
                    self?.hideLoaderFailure(errorLabelTitle: "Send failed", errorLabelMessage: _errorString)
                    return
                } else if let _error = error {
                    self?.hideLoaderFailure(errorLabelTitle: "Send failed", errorLabelMessage: _error.getErrorString())
                    return
                }
                self?.hideLoaderFailure(errorLabelTitle: "Send failed", errorLabelMessage: "Unknown Error")
            }
        }
    }

    func showPasswordRequest() {

        if let sessionWords = SessionManager.shared.getWords() {
            passwordString = sessionWords
            if isStartedSendAction {
                sendMoney()
            }
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

    func updateButtonStatus() {
        if sendButtonTableViewCell == nil {
            return
        }

        if !Validator.isValidCurrencyAddress(currency: currencyString, address: addressString) {
            sendButtonTableViewCell?.isEnabledButton = false
            return
        }

        if addressString.isEmpty || valueString.isEmpty {
            sendButtonTableViewCell?.isEnabledButton = false
            sendButtonTableViewCell?.slidingButton.setText(text: "send.button-fill".localized())
            return
        }

        if let asset = StorageManager.shared.getAsset(id: assetId) {
            sendButtonTableViewCell?.slidingButton.setText(text: "send.button-slide".localized() + valueString + " " + asset.getCurrencySmallString())
            sendButtonTableViewCell?.isEnabledButton = true
        }
    }

    override func keyboardHeightDidChange(with keyboardHeight: CGFloat, duration: Double, curve: UInt) {

        //let newHeight = keyboardHeight < 0 ? 0 : keyboardHeight

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: { [weak self] in
            //self?.contentHeight = self!.sectionsHeight + newHeight
            self?.view.layoutIfNeeded()
        }, completion: { (_) in
            DispatchQueue.main.async {
                //self.tableView.scrollToRow(at: IndexPath(row: self.textFieldEditingIndex, section: 0), at: .bottom, animated: true)
            }
        })

    }

    func startFeesUpdate() {
        if feesRequestActive {
            return
        }

        if updateFeesTimer != nil {
            updateFeesTimer?.invalidate()
            updateFeesTimer = nil
        }

        updateFeesTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(feesUpdateAction), userInfo: nil, repeats: false)
    }

    @objc func feesUpdateAction() {
        if updateFeesTimer != nil {
            updateFeesTimer?.invalidate()
            updateFeesTimer = nil
        }

        loadFeesAction()
    }

    func loadFeesAction() {

        feesRequestActive = true

        let toAddress = addressString
        let fromAddress = assetAddressString

        if let asset = StorageManager.shared.getAsset(id: assetId) {
            if asset.isToken() {

                if !toAddress.isEmpty {
                    showPasswordRequest()

                    let amount = Int(valueString) ?? 1
                    DataManager.shared.getTransactionTokenCost(password: passwordString, symbol: asset.symbol, tokenAddress: fromAddress, toAddress: toAddress, amount: amount) { [weak self] (speedPriceModel, error) in
                        if speedPriceModel != nil {
                            self?.speedPriceModel = speedPriceModel
                        }

                        self?.feesRequestActive = false
                    }
                } else {
                    feesRequestActive = false
                }
            } else {
                DataManager.shared.getTransactionCost(currency: asset.symbol) { [weak self] (speedPriceModel, error) in
                    if speedPriceModel != nil {
                        self?.speedPriceModel = speedPriceModel
                    }

                    self?.feesRequestActive = false
                }
            }
        }
    }


    func startConvertor(isToUSD: Bool) {

        convertorToUSD = isToUSD

        if convertorTimer != nil {
            convertorTimer?.invalidate()
            convertorTimer = nil
        }

        convertorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(convertorTimerAction), userInfo: nil, repeats: false)
    }

    @objc func convertorTimerAction() {
        if convertorTimer != nil {
            convertorTimer?.invalidate()
            convertorTimer = nil
        }

        convertorAction()
    }

    func convertorAction() {

        guard let asset = StorageManager.shared.getAsset(id: assetId) else {
            return
        }

        let convertorToUSD = self.convertorToUSD
        var fromParams = ""
        var toParams = ""
        var amountParams: Double = 0

        if convertorToUSD {
            toParams = "USD"
            fromParams = currencyString
            if asset.isToken() {
                fromParams = assetAddressString
            }
            amountParams = valueString.toDouble
        } else {
            fromParams = "USD"
            toParams = currencyString
            if asset.isToken() {
                toParams = assetAddressString
            }
            amountParams = valueUsdString.toDouble
        }

        DataManager.shared.getConverter(from: fromParams, to: toParams, amount: amountParams) { [weak self] (converterModel, error) in
            if converterModel != nil {
                if convertorToUSD {
                    self?.sendInputTableViewCellUSD?.setText(text: converterModel!.getRate(isUSD: true).cleanValue)
                    self?.valueUsdString = converterModel!.getRate(isUSD: true).cleanValue
                } else {
                    self?.sendInputTableViewCellCrypto?.setText(text: converterModel!.getRate(isUSD: false).cleanValue6)
                    self?.valueString = converterModel!.getRate(isUSD: false).cleanValue6
                }
            }

            self?.updateButtonStatus()
        }

    }
}

extension SendByAddressViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendEmptyTableViewCell.identifier, for: indexPath) as! SendEmptyTableViewCell
            return cell
        case .empty2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendEmptyTableViewCell.identifier, for: indexPath) as! SendEmptyTableViewCell
            return cell
        case .empty3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendEmptyTableViewCell.identifier, for: indexPath) as! SendEmptyTableViewCell
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendInputTableViewCell.identifier, for: indexPath) as! SendInputTableViewCell
            cell.applyData(cellIndex: indexPath.row, placeholder: "send.walletaddress".localized())
            cell.delegate = self
            cell.section = .address
            cell.cellIndex = indexPath.row
            if !addressString.isEmpty {
                cell.setText(text: addressString)
            }
            cell.inputTextField!.keyboardType = .numbersAndPunctuation
            sendInputTableViewCellAddress = cell
            return cell
        case .crypto:
            let asset = StorageManager.shared.getAsset(id: assetId)
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendInputTableViewCell.identifier, for: indexPath) as! SendInputTableViewCell
            cell.applyData(cellIndex: indexPath.row, placeholder: asset!.getCurrencySmallString() + " " + "send.amount".localized())
            cell.delegate = self
            cell.section = .crypto
            cell.cellIndex = indexPath.row
            sendInputTableViewCellCrypto = cell
            cell.inputTextField!.keyboardType = .decimalPad
            return cell
        case .usd:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendInputTableViewCell.identifier, for: indexPath) as! SendInputTableViewCell
            cell.applyData(cellIndex: indexPath.row, placeholder: "USD " + "send.amount".localized())
            cell.delegate = self
            cell.section = .usd
            cell.cellIndex = indexPath.row
            sendInputTableViewCellUSD = cell
            cell.inputTextField!.keyboardType = .decimalPad
            return cell
        case .fees:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendFeesTableViewCell.identifier, for: indexPath) as! SendFeesTableViewCell
            cell.speedPriceModel = speedPriceModel
            cell.applyData(currency: currencyString)
            cell.delegate = self
            sendFeesTableViewCell = cell
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.sendButtonTableViewCell.identifier, for: indexPath) as! SendButtonTableViewCell
            cell.delegate = self
            sendButtonTableViewCell = cell
            updateButtonStatus()
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
}

extension SendByAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case .address:
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.row] {
        case .empty:
            return 25
        case .empty2:
            return 10
        case .empty3:
            return 25
        case .address:
            return 70
        case .crypto:
            return 70
        case .usd:
            return 70
        case .fees:
            return 229
        case .button:
            return 100
        default:
            break
        }
        return 0
    }
}

extension SendByAddressViewController: SendFeesTableViewCellDelegate {
    func sendFeesTableViewCell(_ sendFeesTableViewCell: SendFeesTableViewCell, didChangedFees value: String) {
        feesString = value
    }
}

extension SendByAddressViewController: SendButtonTableViewCellDelegate {
    func sendButtonTableViewCellAction(_ sendButtonTableViewCell: SendButtonTableViewCell) {
        DispatchQueue.main.async { [weak self] in
            self?.sendMoney()
        }
    }
}

extension SendByAddressViewController: EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String) {
        passwordString = password

        if isStartedSendAction {
            sendMoney()
        }
    }
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView) {
        sendButtonTableViewCell?.reset()
    }
}

extension SendByAddressViewController: SendInputTableViewCellDelegate {
    func sendInputTableViewCell(_ sendInputTableViewCell: SendInputTableViewCell, didValueChanged value: String) {
        switch sendInputTableViewCell.section {
            case .address:
                addressString = value
            case .crypto:
                valueString = value
                startConvertor(isToUSD: true)
                //if let converterModel = converterModel {
                //    sendInputTableViewCellUSD?.setText(text: converterModel.getRate(currency: currencyString, value: valueString.toDouble).cleanValue6)
                //}
            case .usd:
                valueUsdString = value
                startConvertor(isToUSD: false)
                //if let converterModel = converterModel {
                //    let usdRate = converterModel.getUSDRate(value: value.toDouble)
                //    valueString = usdRate.cleanValue6
                //    sendInputTableViewCellCrypto?.setText(text: usdRate.cleanValue6)
                //}
            default:
                break
        }

        startFeesUpdate()

        updateButtonStatus()
    }
    func sendInputTableViewCellAction(_ sendInputTableViewCell: SendInputTableViewCell) {

    }
    func sendInputTableViewCellDidBeginEditing(_ sendInputTableViewCell: SendInputTableViewCell) {

    }
}

protocol SendByAddressViewControllerDelegate {
    func sendByAddressViewController(_ sendByAddressViewController: SendByAddressViewController, didHeightChanged value: CGFloat)
}
