//
//  DetailOutcomingCell.swift
//  MMWallet
//
//  Created by Oleg Leizer on 30.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//

import UIKit

class DetailOutcomingCell: UITableViewCell {

    var delegate: DetailOutcomingCellDelegate?

    @IBOutlet weak var directionIconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var statusIconView: UIImageView!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromLabelBackView: UIView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toLabelBackView: UIView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    var tapDirectionFrom: UITapGestureRecognizer?
    var tapDirectionTo: UITapGestureRecognizer?

    var isShowUSD = true
    
    override func awakeFromNib() {
        super.awakeFromNib()

        timeLabel.textColor = UIColor(componentType: .labelPlaceholder)
        balanceLabel.textColor = UIColor(componentType: .navigationText)

        let arrowButtonImage = R.image.arrowRightIcon()
        arrowButton.setImage(arrowButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        arrowButton.tintColor = UIColor(componentType: .labelPlaceholder)

        lineView.backgroundColor = UIColor(componentType: .lineContactBack)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var transactionModel: TransactionModel? {
        didSet {
            if let transactionModel = transactionModel {

                fromLabel.text = ""

                if transactionModel.fromDirection!.name.isEmpty {
                    let attachmentString = NSAttributedString()
                    let hashString = " " + transactionModel.fromDirection!.hashString.prefix(4) + "***" + transactionModel.fromDirection!.hashString.suffix(4)
                    let strLabelText = NSAttributedString(string: String(hashString))
                    let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
                    mutableAttachmentString.append(strLabelText)
                    fromLabel.textColor = Color(componentType: .buttonAddContact)
                    fromLabel.backgroundColor = Color(componentType: .labelAddContactBack)
                    fromLabelBackView.backgroundColor = Color(componentType: .labelAddContactBack)
                    fromLabel.attributedText = mutableAttachmentString

                    if tapDirectionFrom == nil {
                        tapDirectionFrom = UITapGestureRecognizer(target: self, action: #selector(self.handleDirectionFromTap(_:)))
                        fromLabelBackView.addGestureRecognizer(tapDirectionFrom!)
                        fromLabelBackView.isUserInteractionEnabled = true
                    }

                    if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                        fromLabelBackView.setCornerRadius(radius: 2)
                        fromLabelBackView.layer.borderColor = Color(componentType: .buttonAddContact).cgColor
                        fromLabelBackView.layer.borderWidth = 1
                        fromLabelBackView.backgroundColor = UIColor.clear
                        fromLabel.backgroundColor = UIColor.clear
                    }

                } else {
                    fromLabel.text = transactionModel.fromDirection!.name
                    if transactionModel.fromDirection!.name == "Me" {
                        fromLabel.textColor = Color(componentType: .buttonMeContact)
                        fromLabel.backgroundColor = Color(componentType: .labelMeContactBack)
                        fromLabelBackView.backgroundColor = Color(componentType: .labelMeContactBack)

                        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                            fromLabelBackView.setCornerRadius(radius: 2)
                            fromLabelBackView.layer.borderColor = Color(componentType: .buttonMeContact).cgColor
                            fromLabelBackView.layer.borderWidth = 1
                            fromLabelBackView.backgroundColor = UIColor.clear
                            fromLabel.backgroundColor = UIColor.clear
                        }
                    } else {
                        fromLabel.textColor = Color(componentType: .buttonNotMeContact)
                        fromLabel.backgroundColor = Color(componentType: .labelNotMeContactBack)
                        fromLabelBackView.backgroundColor = Color(componentType: .labelNotMeContactBack)

                        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                            fromLabelBackView.setCornerRadius(radius: 2)
                            fromLabelBackView.layer.borderColor = Color(componentType: .buttonNotMeContact).cgColor
                            fromLabelBackView.layer.borderWidth = 1
                            fromLabelBackView.backgroundColor = UIColor.clear
                            fromLabel.backgroundColor = UIColor.clear
                        }
                    }

                    fromLabelBackView.isUserInteractionEnabled = false
                    if tapDirectionFrom != nil {
                        fromLabelBackView.removeGestureRecognizer(tapDirectionFrom!)
                        tapDirectionFrom = nil
                    }
                }

                toLabel.text = ""
                if transactionModel.toDirection!.name.isEmpty {
                    let attachmentString = NSAttributedString()

                    let hashString = " " + transactionModel.toDirection!.hashString.prefix(4) + "***" + transactionModel.toDirection!.hashString.suffix(4)
                    let strLabelText = NSAttributedString(string: String(hashString))
                    let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
                    mutableAttachmentString.append(strLabelText)
                    toLabel.textColor = Color(componentType: .buttonAddContact)
                    toLabel.backgroundColor = Color(componentType: .labelAddContactBack)
                    toLabelBackView.backgroundColor = Color(componentType: .labelAddContactBack)
                    toLabel.attributedText = mutableAttachmentString

                    if tapDirectionTo == nil {
                        tapDirectionTo = UITapGestureRecognizer(target: self, action: #selector(self.handleDirectionToTap(_:)))
                        toLabelBackView.addGestureRecognizer(tapDirectionTo!)
                        toLabelBackView.isUserInteractionEnabled = true
                    }

                    if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                        toLabelBackView.setCornerRadius(radius: 2)
                        toLabelBackView.layer.borderColor = Color(componentType: .buttonAddContact).cgColor
                        toLabelBackView.layer.borderWidth = 1
                        toLabelBackView.backgroundColor = UIColor.clear
                        toLabel.backgroundColor = UIColor.clear
                    }
                } else {
                    toLabel.text = transactionModel.toDirection!.name
                    if transactionModel.toDirection!.name == "Me" {
                        toLabel.textColor = Color(componentType: .buttonMeContact)
                        toLabel.backgroundColor = Color(componentType: .labelMeContactBack)
                        toLabelBackView.backgroundColor = Color(componentType: .labelMeContactBack)

                        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                            toLabelBackView.setCornerRadius(radius: 2)
                            toLabelBackView.layer.borderColor = Color(componentType: .buttonMeContact).cgColor
                            toLabelBackView.layer.borderWidth = 1
                            toLabelBackView.backgroundColor = UIColor.clear
                            toLabel.backgroundColor = UIColor.clear
                        }
                    } else {
                        toLabel.textColor = Color(componentType: .buttonNotMeContact)
                        toLabel.backgroundColor = Color(componentType: .labelNotMeContactBack)
                        toLabelBackView.backgroundColor = Color(componentType: .labelNotMeContactBack)

                        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
                            toLabelBackView.setCornerRadius(radius: 2)
                            toLabelBackView.layer.borderColor = Color(componentType: .buttonNotMeContact).cgColor
                            toLabelBackView.layer.borderWidth = 1
                            toLabelBackView.backgroundColor = UIColor.clear
                            toLabel.backgroundColor = UIColor.clear
                        }
                    }

                    toLabelBackView.isUserInteractionEnabled = false
                    if tapDirectionTo != nil {
                        toLabelBackView.removeGestureRecognizer(tapDirectionTo!)
                        tapDirectionTo = nil
                    }
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                timeLabel.text = dateFormatter.string(from: transactionModel.createdAt!)

                statusLabel.text = transactionModel.status.capitalizingFirstLetter()

                switch transactionModel.status {
                    case "success":
                        statusIconView.image = R.image.statusDone()
                        statusLabel.textColor = Color(componentType: .labelStatusDone)
                    case "cancelled":
                        statusIconView.image = R.image.statusCancelled()
                        statusLabel.textColor = Color(componentType: .labelStatusCancelled)
                    case "pending":
                        statusIconView.image = R.image.statusPending()
                        statusLabel.textColor = Color(componentType: .labelStatusPending)
                    default:
                        statusIconView.image = nil
                }

                if isShowUSD {
                    if transactionModel.tokenRate != nil {
                        let value = transactionModel.tokenRate!.USD * transactionModel.tokenAmount.value!
                        balanceLabel.text =  "\(value.cleanValue) USD"
                    } else {
                        balanceLabel.text =  "\(transactionModel.rate!.USD.cleanValue) USD"
                    }
                } else {
                    if transactionModel.tokenAmount.value != nil {
                        balanceLabel.text = "\(transactionModel.tokenAmount.value!.cleanValue6) \(transactionModel.symbol)"
                    } else {
                        balanceLabel.text = "\(transactionModel.amount.cleanValue6) \(transactionModel.symbol)"
                    }
                }

                switch transactionModel.direction {
                    case "in":
                        directionIconView.image = R.image.incomingIcon()
                        balanceLabel.text = "+ \(balanceLabel.text!)"
                    case "out":
                        directionIconView.image = R.image.outcominIcon()
                        balanceLabel.text = "- \(balanceLabel.text!)"
                    default:
                        directionIconView.image = nil
                }
            }
        }
    }

    @objc func handleDirectionFromTap(_ sender: UITapGestureRecognizer) {
        guard let transactionModel = transactionModel else { return }

        delegate?.detailOutcomingCellAddContactDirectionFrom(self, fromTransaction: transactionModel.id)
    }

    @objc func handleDirectionToTap(_ sender: UITapGestureRecognizer) {
        guard let transactionModel = transactionModel else { return }

        delegate?.detailOutcomingCellAddContactDirectionTo(self, fromTransaction: transactionModel.id)
    }
}

protocol DetailOutcomingCellDelegate {
    func detailOutcomingCellAddContactDirectionFrom(_ detailOutcomingCell: DetailOutcomingCell, fromTransaction transactionModelId: Int?)
    func detailOutcomingCellAddContactDirectionTo(_ detailOutcomingCell: DetailOutcomingCell, fromTransaction transactionModelId: Int?)
}
