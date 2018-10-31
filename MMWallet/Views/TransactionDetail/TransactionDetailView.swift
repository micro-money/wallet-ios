//
//  TransactionDetailView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 22.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TransactionDetailView: UIView {

    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let closeButtonImage = R.image.closeIcon()
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            closeButton.tintColor = UIColor(componentType: .popButtonClose)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {

            tableView.delegate = self
            tableView.dataSource = self

            tableView.register(R.nib.transactionDetailLoadingTableViewCell)
            tableView.register(R.nib.transactionDetailTableViewCell)
            tableView.register(R.nib.transactionDetailInputTableViewCell)
            tableView.register(R.nib.transactionDetailStatusTableViewCell)
            tableView.register(R.nib.transactionDetailDirectionTableViewCell)

            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.clipsToBounds = true
            backView.layer.cornerRadius = 14
            backView.backgroundColor = UIColor(componentType: .popBackground)
        }
    }

    var cells: [UITableViewCell] = []
    var cellsHeight: [CGFloat] = []

    var transactionDetailModel: TransactionDetailModel?
    var transactionId: Int = 0

    var transactionIDTableViewCell: TransactionDetailDirectionTableViewCell?
    
    func configureView(transactionId: Int) {
        self.transactionId = transactionId

        configureLoadingTable()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.backViewHeightConstraint.constant + 28 + 41)
            self.tableView.reloadData()
            self.loadData()
        }

    }

    func loadData() {
        DataManager.shared.getTransaction(id: transactionId) { [weak self] (transactionDetailModel, error) in
            if error == nil {
                self?.transactionDetailModel = transactionDetailModel
                self?.configureTable()
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }

    func configureLoadingTable() {
        cells = []
        cellsHeight = []

        let cell = R.nib.transactionDetailLoadingTableViewCell.firstView(owner: nil)!
        cell.selectionStyle = .none
        cells.append(cell)
        cellsHeight.append(cell.getHeight())

        backViewHeightConstraint.constant = cell.getHeight() + 36 + 25
        backViewTopConstraint.constant = self.bounds.height*0.5 - 41*2 - 36

        tableView.reloadData()
    }

    func configureTable() {

        cells = []
        cellsHeight = []

        guard let transactionDetailModel = transactionDetailModel else { return }

        backViewTopConstraint.constant = 41

        //To:
        let cellID = R.nib.transactionDetailDirectionTableViewCell.firstView(owner: nil)!
        cellID.applyData(titleString: "Transaction ID:", dataString: transactionDetailModel.hashString)
        cellID.delegate = self
        transactionIDTableViewCell = cellID
        cells.append(cellID)
        cellsHeight.append(cellID.getHeight())

        //TimeStamp:
        let dateFromFormatter = DateFormatter()
        dateFromFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFromFormatter.dateFormat = "MMM-dd-yyyy hh:mm:ss a ZZZZ"
        let cell6 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
        cell6.applyData(titleString: "TimeStamp:", dataString: dateFromFormatter.string(from: transactionDetailModel.createdAt!))
        cells.append(cell6)
        cellsHeight.append(cell6.getHeight())

        if let inputModel = transactionDetailModel.inputModel {
            //Contract:
            let cellContract = R.nib.transactionDetailDirectionTableViewCell.firstView(owner: nil)!
            cellContract.applyData(titleString: "Contract:", dataString: inputModel.token!.hashString)
            cellContract.delegate = self
            cells.append(cellContract)
            cellsHeight.append(cellContract.getHeight())

            //From:
            let cellFrom = R.nib.transactionDetailDirectionTableViewCell.firstView(owner: nil)!
            cellFrom.applyData(titleString: "From:", dataString: transactionDetailModel.fromDirection!.hashString)
            cellFrom.delegate = self
            cells.append(cellFrom)
            cellsHeight.append(cellFrom.getHeight())

            //To:
            let cellTo = R.nib.transactionDetailDirectionTableViewCell.firstView(owner: nil)!
            cellTo.applyData(titleString: "To:", dataString: transactionDetailModel.toDirection!.hashString)
            cellTo.delegate = self
            cells.append(cellTo)
            cellsHeight.append(cellTo.getHeight())

            //tokenAmount
            let cellTokenAmount = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
            var valueUSD = ""
            if let rate = inputModel.tokenRate {
                valueUSD = " (USD \(rate.USD.cleanValue))"
            }
            cellTokenAmount.applyData(titleString: "Token Amount:", dataString: "\(inputModel.tokenAmount.cleanValue6) \(transactionDetailModel.symbol) \(valueUSD)")
            cells.append(cellTokenAmount)
            cellsHeight.append(cellTokenAmount.getHeight())
        } else {
            //From:
            let cellFrom = R.nib.transactionDetailDirectionTableViewCell.firstView(owner: nil)!
            cellFrom.applyData(titleString: "From:", dataString: transactionDetailModel.fromDirection!.hashString)
            cellFrom.delegate = self
            cells.append(cellFrom)
            cellsHeight.append(cellFrom.getHeight())

            //To:
            let cellTo = R.nib.transactionDetailDirectionTableViewCell.firstView(owner: nil)!
            cellTo.applyData(titleString: "To:", dataString: transactionDetailModel.toDirection!.hashString)
            cellTo.delegate = self
            cells.append(cellTo)
            cellsHeight.append(cellTo.getHeight())
        }

        //Category:
        //var cell3 = R.nib.transactionDetailInputTableViewCell.firstView(owner: nil)!
        //cells.append(cell3)
        //cellsHeight.append(86)

        //TxReceipt Status:
        let cell2 = R.nib.transactionDetailStatusTableViewCell.firstView(owner: nil)!
        cell2.applyData(titleString: "TxReceipt Status:", dataString: transactionDetailModel.status)
        cells.append(cell2)
        cellsHeight.append(cell2.getHeight())

        //Value:
        let cell9 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
        var valueUSD = ""
        if let rate = transactionDetailModel.rate {
            valueUSD = " (USD \(rate.USD.cleanValue))"
        }
        cell9.applyData(titleString: "Amount:", dataString: transactionDetailModel.amount.cleanValue6 + " " + transactionDetailModel.currency + valueUSD)
        cells.append(cell9)
        cellsHeight.append(cell9.getHeight())

        //Description
        let cell4 = R.nib.transactionDetailInputTableViewCell.firstView(owner: nil)!
        cell4.applyData(titleString: "Description:", dataString: transactionDetailModel.descr)
        cells.append(cell4)
        cellsHeight.append(cell4.getHeight())

        //Block Hash
        let cellBlockHash = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
        cellBlockHash.applyData(titleString: "Block Hash:", dataString: transactionDetailModel.blockHash)
        cells.append(cellBlockHash)
        cellsHeight.append(cellBlockHash.getHeight())

        //Block Height:
        if transactionDetailModel.blockNumber != 0 {
            let cell5 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
            cell5.applyData(titleString: "Block Height:", dataString: "\(transactionDetailModel.blockNumber)")
            cells.append(cell5)
            cellsHeight.append(cell5.getHeight())
        }

        //Gas Limit:
        //var cell10 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
        //cells.append(cell10)
        //cellsHeight.append(62)

        //Gas Used By Txn:
        if transactionDetailModel.gas != 0 {
            let cell11 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
            cell11.applyData(titleString: "Gas Used By Txn:", dataString: "\(transactionDetailModel.gas)")
            cells.append(cell11)
            cellsHeight.append(cell11.getHeight())
        }

        //Gas Price:
        if transactionDetailModel.gasPrice != 0 {
            let cell12 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
            cell12.applyData(titleString: "Gas Price:", dataString: "\(transactionDetailModel.gasPrice)")
            cells.append(cell12)
            cellsHeight.append(cell12.getHeight())
        }

        //Actual Tx Cost/Fee:
        //var cell13 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
        //cells.append(cell13)
        //cellsHeight.append(62)

        //Cumulative Gas Used:
        //var cell14 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
        //cells.append(cell14)
        //cellsHeight.append(62)

        //Nonce:
        if transactionDetailModel.nonce != 0 {
            let cell15 = R.nib.transactionDetailTableViewCell.firstView(owner: nil)!
            cell15.applyData(titleString: "Nonce:", dataString: "\(transactionDetailModel.nonce)")
            cells.append(cell15)
            cellsHeight.append(cell15.getHeight())
        }

        //Input Data
        if !transactionDetailModel.input.isEmpty {
            let cell16 = R.nib.transactionDetailInputTableViewCell.firstView(owner: nil)!
            cell16.applyData(titleString: "Input Data:", dataString: transactionDetailModel.input)
            cells.append(cell16)
            cellsHeight.append(cell16.getHeight())
        } else {
            if let inputModel = transactionDetailModel.inputModel {
                let cell16 = R.nib.transactionDetailInputTableViewCell.firstView(owner: nil)!
                cell16.applyData(titleString: "Input Data:", dataString: inputModel.data)
                cells.append(cell16)
                cellsHeight.append(cell16.getHeight())
            }
        }

        calcContentHeight()
    }

    func calcContentHeight() {
        var finalHeight: CGFloat = 0
        for cellHeight in cellsHeight {
            finalHeight += cellHeight
        }
        finalHeight += 36
        finalHeight += 25
        backViewHeightConstraint.constant = finalHeight

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height:  self.backViewHeightConstraint.constant + 28 + 41)
            self.tableView.reloadData()
        }
    }

    func showQR(hashString: String) {
        let assetQRView = R.nib.assetQRView.firstView(owner: nil)
        UIApplication.shared.keyWindow?.addSubview(assetQRView!)
        assetQRView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        assetQRView!.hashString = hashString
    }
}

extension TransactionDetailView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}

extension TransactionDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellsHeight.count == 0 {
            return 62
        }
        return cellsHeight[indexPath.row]
    }
}

extension TransactionDetailView: TransactionDetailDirectionTableViewCellDelegate {
    func transactionDetailDirectionTableViewCell(_ transactionDetailDirectionTableViewCell: TransactionDetailDirectionTableViewCell, didSelect hashString: String?) {
        if transactionDetailDirectionTableViewCell == transactionIDTableViewCell {
            guard let transactionDetailModel = transactionDetailModel else { return }

            let currentNetwork = NetworkType(rawValue: transactionDetailModel.network)
            guard let url = URL(string: currentNetwork!.getLink(hash: transactionDetailModel.hashString)) else {
                return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return
        }

        if let hashString = hashString {
            showQR(hashString: hashString)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
