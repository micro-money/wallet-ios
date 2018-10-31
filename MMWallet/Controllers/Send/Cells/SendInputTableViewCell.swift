//
//  SendInputTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SendInputTableViewCell: UITableViewCell {
    
    var delegate: SendInputTableViewCellDelegate?
    
    var cellIndex = 0
    var section: SendByAddressSections = .none
    
    @IBOutlet weak var inputTextField: ClearTextField!

    var validationState: ValidationState = .none {
        didSet {
            inputTextField?.validationState = validationState
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        self.backgroundColor = UIColor(componentType: .viewBackground)
    }

    func applyData(cellIndex: Int, placeholder: String) {
        self.cellIndex = cellIndex
        inputTextField.placeholder = placeholder
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        inputTextField.textColor = Color(componentType: .textFieldText)
        inputTextField.backgroundColor = UIColor(componentType: .textFieldBackground)

        self.backgroundColor = UIColor(componentType: .viewBackground)
    }

    func setText(text: String){
        inputTextField.text = text
    }
}

extension SendInputTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.sendInputTableViewCell(self, didValueChanged: textField.text!)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.sendInputTableViewCellAction(self)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.sendInputTableViewCellDidBeginEditing(self)
    }
}

protocol SendInputTableViewCellDelegate {
    func sendInputTableViewCell(_ sendInputTableViewCell: SendInputTableViewCell, didValueChanged value: String)
    func sendInputTableViewCellAction(_ sendInputTableViewCell: SendInputTableViewCell)
    func sendInputTableViewCellDidBeginEditing(_ sendInputTableViewCell: SendInputTableViewCell)
}
