//
//  InputTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 21.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {

    var delegate: InputTableViewCellDelegate?

    static let kCellHeight: CGFloat = 85

    var index = 0
    
    @IBOutlet weak var topInputConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: ClearTextField!

    var validationState: ValidationState = .none {
        didSet {
            inputTextField?.validationState = validationState
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor(componentType: .viewBackground)
        inputTextField.sharedSetup()
    }
    
    func applyData(placeholder: String, value: String) {
        inputTextField.placeholder = placeholder
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        inputTextField.text = value

        selectionStyle = .none
        configureView()
    }
}

extension InputTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.inputTableViewCell(self, didValueChanged: textField.text!)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.inputTableViewCellAction(self)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.inputTableViewCellDidBeginEditing(self)
    }
}

protocol InputTableViewCellDelegate {
    func inputTableViewCell(_ inputTableViewCell: InputTableViewCell, didValueChanged value: String)
    func inputTableViewCellAction(_ inputTableViewCell: InputTableViewCell)
    func inputTableViewCellDidBeginEditing(_ inputTableViewCell: InputTableViewCell)
}
