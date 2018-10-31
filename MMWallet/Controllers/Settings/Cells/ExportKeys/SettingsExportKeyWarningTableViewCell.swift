//
//  SettingsExportKeyWarningTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 07.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SettingsExportKeyWarningTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            let attributedString = NSMutableAttributedString(string: "Warning: Export plain private key is very dangerous. We recommended you backup with mnemonic or keystore.", attributes: [
                .font: FontFamily.SFProText.regular.font(size: 15),
                .foregroundColor: UIColor(componentType: .navigationText),
                .kern: 0.0
            ])
            attributedString.addAttribute(.font, value: FontFamily.SFProText.semibold.font(size: 14), range: NSRange(location: 0, length: 8))
            messageLabel.attributedText = attributedString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configureView()
    }

    func configureView() {

        self.backgroundColor = UIColor(componentType: .viewBackground)
        backView.backgroundColor = UIColor(componentType: .orangeFieldBackground)

        backView.setCornerRadius(radius: 4)
        backView.layer.borderColor = Color(componentType: .buttonTintNext).cgColor
        backView.layer.borderWidth = 1
    }

    func applyData(title: String) {

        let attributedString = NSMutableAttributedString(string: title, attributes: [
            .font: FontFamily.SFProText.regular.font(size: 15),
            .foregroundColor: UIColor(componentType: .navigationText),
            .kern: 0.0
        ])
        attributedString.addAttribute(.font, value: FontFamily.SFProText.semibold.font(size: 14), range: NSRange(location: 0, length: 8))
        messageLabel.attributedText = attributedString

        configureView()
    }

}
