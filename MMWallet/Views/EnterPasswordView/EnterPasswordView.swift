//
//  EnterPasswordView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 25/10/2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class EnterPasswordView: UIView {

    var delegate: EnterPasswordViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var centerBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var passwordTextField: ClearTextField!
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.clipsToBounds = true
            backView.layer.cornerRadius = 14
            backView.backgroundColor = UIColor(componentType: .popBackground)
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let closeButtonImage = R.image.closeIcon()
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            closeButton.tintColor = UIColor(componentType: .popButtonClose)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        configureView()
    }
    
    func configureView() {
        
        okButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        okButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)
        
        okButton.backgroundColor = Color(componentType: .buttonFill)
        okButton.layer.cornerRadius = 5
        
        titleLabel.textColor = UIColor(componentType: .navigationText)
        titleLabel.text = "password.title".localized()
        
        subtitleLabel.textColor = UIColor(componentType: .navigationText)
        subtitleLabel.text = "password.subtitle".localized()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.enterPasswordViewClose(self)
        removeFromSuperview()
    }
    
    @IBAction func okAction(_ sender: Any) {
        delegate?.enterPasswordView(self, requestAction: passwordTextField.text!)
        removeFromSuperview()
    }
    
    @IBAction func editBeginAction(_ sender: Any) {
        centerBackViewConstraint.constant = -(UIScreen.main.bounds.height - backView.bounds.width)*0.25
    }
    
    @IBAction func editEndAction(_ sender: Any) {
        centerBackViewConstraint.constant = 0
    }
}

protocol EnterPasswordViewDelegate {
    func enterPasswordView(_ enterPasswordView: EnterPasswordView, requestAction password: String)
    func enterPasswordViewClose(_ enterPasswordView: EnterPasswordView)
}
