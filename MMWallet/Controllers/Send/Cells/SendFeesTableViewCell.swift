//
//  SendFeesTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SendFeesTableViewCell: UITableViewCell {

    var delegate: SendFeesTableViewCellDelegate?

    @IBOutlet weak var placeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mempoolSizeLabel: UILabel!
    @IBOutlet weak var transactionSizeLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var lowPlaceView: UIView! {
        didSet {
            feesViewLow = R.nib.feesView.firstView(owner: nil)

            lowPlaceView.addSubview(feesViewLow!)
            feesViewLow!.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(self.lowPlaceView)
            }

            feesViewLow?.levelLabel.text = "low".uppercased()
            feesViewLow?.isSelected = true
            feesViewLow?.reportIconView.isHidden = false

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapLowAction(_:)))
            feesViewLow?.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var medPlaceView: UIView! {
        didSet {
            feesViewMed = R.nib.feesView.firstView(owner: nil)

            medPlaceView.addSubview(feesViewMed!)
            feesViewMed!.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(self.medPlaceView)
            }

            feesViewMed?.levelLabel.text = "moderate".uppercased()
            feesViewMed?.isSelected = false
            feesViewMed?.reportIconView.isHidden = true

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapMedAction(_:)))
            feesViewMed?.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var hightPlaceView: UIView!  {
        didSet {
            feesViewHi = R.nib.feesView.firstView(owner: nil)

            hightPlaceView.addSubview(feesViewHi!)
            feesViewHi!.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(self.hightPlaceView)
            }

            feesViewHi?.levelLabel.text = "High".uppercased()
            feesViewHi?.isSelected = false
            feesViewHi?.reportIconView.isHidden = true

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHiAction(_:)))
            feesViewHi?.addGestureRecognizer(tap)
        }
    }

    var feesViewLow: FeesView?
    var feesViewMed: FeesView?
    var feesViewHi: FeesView?

    var speedPriceModel: SpeedPriceModel? {
        didSet {
            if let speedPriceModel = speedPriceModel {
                feesViewLow?.spbLabel.text = speedPriceModel.low!.getRate().cleanValue6 + " " + currencyString
                feesViewMed?.spbLabel.text = speedPriceModel.medium!.getRate().cleanValue6 + " " + currencyString
                feesViewHi?.spbLabel.text = speedPriceModel.high!.getRate().cleanValue6 + " " + currencyString

                feesViewLow?.timeLabel.text = "(estimate 30+ min)"
                feesViewMed?.timeLabel.text = "(estimate ~5 min)"
                feesViewHi?.timeLabel.text = "(estimate ~2 min)"

                updateFeesText()
            }
        }
    }

    var currencyString: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none

        self.backgroundColor = UIColor(componentType: .viewBackground)
        containerView.backgroundColor = UIColor(componentType: .feesBackground)
        titleLabel.textColor = UIColor(componentType: .navigationText)
    }

    func applyData(currency: String) {
        currencyString = currency

        updateFeesText()

        placeWidthConstraint.constant = (self.bounds.width - 30)/3
    }

    func updateFeesText() {
        //Mining fee 2.36 USD (0.0000235 ETH)

        feeLabel.text = ""

        var feeValue: Double = 0.0

        if feesViewLow!.isSelected && speedPriceModel?.low != nil {
            feeValue = speedPriceModel!.low!.getRate()
            feeLabel.text = "Mining fee \(speedPriceModel!.low!.USD.cleanValue6) USD (\(feeValue.cleanValue6) \(currencyString) )"
        }
        if feesViewMed!.isSelected && speedPriceModel?.medium != nil {
            feeValue = speedPriceModel!.medium!.getRate()
            feeLabel.text = "Mining fee \(speedPriceModel!.medium!.USD.cleanValue6) USD (\(feeValue.cleanValue6) \(currencyString) )"
        }
        if feesViewHi!.isSelected && speedPriceModel?.high != nil {
            feeValue = speedPriceModel!.high!.getRate()
            feeLabel.text = "Mining fee \(speedPriceModel!.high!.USD.cleanValue6) USD (\(feeValue.cleanValue6) \(currencyString) )"
        }
    }

    @objc func tapLowAction(_ sender: UITapGestureRecognizer) {
        feesViewLow?.isSelected = true
        feesViewMed?.isSelected = false
        feesViewHi?.isSelected = false

        delegate?.sendFeesTableViewCell(self, didChangedFees: "low")

        updateFeesText()
    }

    @objc func tapMedAction(_ sender: UITapGestureRecognizer) {
        feesViewLow?.isSelected = false
        feesViewMed?.isSelected = true
        feesViewHi?.isSelected = false

        delegate?.sendFeesTableViewCell(self, didChangedFees: "medium")

        updateFeesText()
    }

    @objc func tapHiAction(_ sender: UITapGestureRecognizer) {
        feesViewLow?.isSelected = false
        feesViewMed?.isSelected = false
        feesViewHi?.isSelected = true

        delegate?.sendFeesTableViewCell(self, didChangedFees: "high")

        updateFeesText()
    }
}

protocol SendFeesTableViewCellDelegate {
    func sendFeesTableViewCell(_ sendFeesTableViewCell: SendFeesTableViewCell, didChangedFees value: String)
}
