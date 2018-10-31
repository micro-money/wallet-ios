//
//  SettingsExportKeyInputTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class SettingsExportKeyInputTableViewCell: UITableViewCell {

    var delegate: SettingsExportKeyInputTableViewCellDelegate?
    
    var index = 0
    
    @IBOutlet weak var shadowBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView! {
        didSet {
            inputTextView.placeholderColor = Color(componentType: .labelPlaceholder)
            inputTextView.textContainerInset =  UIEdgeInsets.init(top: 35, left: 8, bottom: 35, right: 8)
            inputTextView.delegate = self
            inputTextView.textColor = Color(componentType: .textFieldText)
            inputTextView.backgroundColor = UIColor(componentType: .textFieldBackground)
        }
    }
    
    override func layoutSubviews() {
        shadowBackView.layer.shadowColor = UIColor.black.cgColor
        shadowBackView.layer.shadowOffset = CGSize(width: 0.0, height: 0.8)
        shadowBackView.layer.shadowRadius = 2
        shadowBackView.layer.shadowOpacity = 0.05
        //        containerView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: shadowBackView.frame.width, height: shadowBackView.frame.height))
        shadowBackView.layer.shadowPath = path.cgPath
    }
    
    func applyData(title: String, placeholder: String) {
        inputTextView.placeholder = placeholder.localized()
        titleLabel.text = title.localized()
    }
}

extension SettingsExportKeyInputTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.settingsExportKeyInputTableViewCell(self, didValueChanged: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.settingsExportKeyInputTableViewCellDidBeginEditing(self)
    }
}

protocol SettingsExportKeyInputTableViewCellDelegate {
    func settingsExportKeyInputTableViewCell(_ settingsExportKeyInputTableViewCell: SettingsExportKeyInputTableViewCell, didValueChanged value: String)
    //func settingsExportKeyInputTableViewCellAction(_ importWalletInputBigTableViewCell: SettingsExportKeyInputTableViewCell)
    func settingsExportKeyInputTableViewCellDidBeginEditing(_ settingsExportKeyInputTableViewCell: SettingsExportKeyInputTableViewCell)
}
