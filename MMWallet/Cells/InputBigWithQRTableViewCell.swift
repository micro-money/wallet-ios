//
//  InputBigWithQRTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 18.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class InputBigWithQRTableViewCell: UITableViewCell {
    
    var delegate: InputBigWithQRTableViewCellDelegate?
    
    var index = 0
    
    @IBOutlet weak var statusLineView: UIView!
    @IBOutlet weak var shadowBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    
    var validationState: ValidationState = .none {
        didSet {
            if validationState == .error {
                statusLineView.backgroundColor = Color(componentType: .textFieldErrorLine)
            } else {
                statusLineView.backgroundColor = Color(componentType: .textFieldNormalLine)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
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
    
    func configureView() {

        shadowBackView.backgroundColor = UIColor(componentType: .textFieldBackground)

        if validationState == .error {
            statusLineView.backgroundColor = Color(componentType: .textFieldErrorLine)
        } else {
            statusLineView.backgroundColor = Color(componentType: .textFieldNormalLine)
        }
        
        backgroundColor = UIColor(componentType: .viewBackground)
        inputTextView.placeholderColor = Color(componentType: .labelPlaceholder)
        inputTextView.textContainerInset =  UIEdgeInsets.init(top: 35, left: 8, bottom: 35, right: 8)
        inputTextView.delegate = self
        inputTextView.textColor = Color(componentType: .textFieldText)
        inputTextView.backgroundColor = UIColor(componentType: .textFieldBackground)
        inputTextView.keyboardType = .numbersAndPunctuation
        
        selectionStyle = .none
    }
    
    func applyData(title: String, placeholder: String, text: String) {
        inputTextView.placeholder = placeholder
        inputTextView.text = text
        titleLabel.text = title
        
        configureView()
    }
}

extension InputBigWithQRTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            delegate?.inputBigWithQRTableViewCellAction(self)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.inputBigWithQRTableViewCell(self, didValueChanged: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.inputBigWithQRTableViewCellDidBeginEditing(self)
    }
}

protocol InputBigWithQRTableViewCellDelegate {
    func inputBigWithQRTableViewCell(_ inputBigWithQRTableViewCell: InputBigWithQRTableViewCell, didValueChanged value: String)
    func inputBigWithQRTableViewCellDidBeginEditing(_ inputBigWithQRTableViewCell: InputBigWithQRTableViewCell)
    func inputBigWithQRTableViewCellAction(_ inputBigWithQRTableViewCell: InputBigWithQRTableViewCell)
}
