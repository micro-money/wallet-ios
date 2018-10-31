//
//  TermsViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 02.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TermsViewController: BaseViewController {

    var delegate: TermsViewControllerDelegate?

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var iagreeButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(isRefresh: false)

        webView.delegate = self

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if let url = URL(string: ApiManager.shared.getServerUrl() + WalletConstants.termsURL) {
                let urlRequest = URLRequest(url: url)
                self?.webView?.loadRequest(urlRequest)
            }
        }
    }

    override func configureView(isRefresh: Bool) {

        self.view.backgroundColor = UIColor(componentType: .viewBackground)

        self.webView.backgroundColor = UIColor(componentType: .viewBackground)
        self.backButtonView.backgroundColor = UIColor(componentType: .viewBackground)

        self.iagreeButton.setTitle("common.actions.iagree".localized().uppercased(), for: .normal)
        self.iagreeButton.setTitleColor(Color(componentType: .buttonTitleNormal), for: .normal)
        self.iagreeButton.setTitleColor(Color(componentType: .buttonTitleDisable), for: .disabled)

        self.iagreeButton.backgroundColor = Color(componentType: .buttonFill)
        self.iagreeButton.layer.cornerRadius = 5
    }
    
    @IBAction func buttonAction(_ sender: Any) {

        dismiss(animated: true) { [weak self] in
            self?.delegate?.termsViewControllerAction(self!)
        }
    }
}

extension TermsViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityView.isHidden = false
        activityView.startAnimating()
        iagreeButton.isEnabled = false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityView.isHidden = true
        iagreeButton.isEnabled = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityView.isHidden = true
        iagreeButton.isEnabled = true
    }
}

protocol TermsViewControllerDelegate {
    func termsViewControllerAction(_ termsViewController: TermsViewController)
}
