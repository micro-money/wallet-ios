//
//  SendViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 30.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class SendViewController: BaseViewController, Messageable, Loadable {

    var delegate: SendViewControllerDelegate?

    @IBOutlet weak var placeHeaderVIew: UIView!
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            let backButtonImage = R.image.back14Icon()
            backButton.setImage(backButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            backButton.tintColor = UIColor(componentType: .buttonsReceiveInput)
            backButton.setTitleColor(UIColor(componentType: .navigationText), for: .normal)
        }
    }
    @IBOutlet weak var backPanelView: UIView!
    @IBOutlet fileprivate var containerView: UIView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lineView: UIView!
    
    var assetsId: Int = 0
    var address: String?

    func applyData(assetsId: Int, address: String? = nil) {
        self.assetsId = assetsId
        self.address = address
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView(isRefresh: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        delegate?.sendViewControllerClosed(self)
    }

    override func configureView(isRefresh: Bool) {

        self.view.backgroundColor = UIColor(componentType: .viewBackground)
        lineView.backgroundColor = UIColor(componentType: .carbonLine)


        backPanelView.layer.shadowColor = UIColor.black.cgColor
        backPanelView.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        backPanelView.layer.shadowRadius = 2
        backPanelView.layer.shadowOpacity = 0.05
        //        containerView.layer.masksToBounds = false
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: backPanelView.frame.width, height: backPanelView.frame.height))
        backPanelView.layer.shadowPath = path.cgPath

        backPanelView.backgroundColor = UIColor(componentType: .subNavigationBackground)

        if let asset = StorageManager.shared.getAsset(id: assetsId) {
            let sendString = "send.send".localized() + asset.getCurrencySmallString()
            backButton.setTitle(sendString, for: .normal)

        }

        addHeaderView()

        if !isRefresh {
            addSendView()
        }
    }

    func addHeaderView() {
        let headerView = R.nib.assetDetailHeaderView.firstView(owner: nil)

        placeHeaderVIew.addSubview(headerView!)
        headerView!.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.placeHeaderVIew)
        }

        headerView!.currencyChartYOffset = 5
        headerView!.currencyChartTopOffset = 30

        headerView!.assetSmallModel = StorageManager.shared.getAsset(id: assetsId)
    }
    
    func addSendView() {

        let vcAddress = R.storyboard.send.sendByAddressViewController()!
        if let asset = StorageManager.shared.getAsset(id: assetsId) {
            vcAddress.applyData(currency: asset.currency, assetId: asset.id, address: address)
        }
        vcAddress.delegate = self
        
        // fast simplification from CarbonKit
        self.addChild(vcAddress)
        containerView.addSubview(vcAddress.view)
        vcAddress.view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.containerView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //view.layoutIfNeeded()
        //let width = carbonTabSwipeNavigation?.carbonTabSwipeScrollView.contentSize.width ?? 0
        //carbonTabSwipeNavigation?.carbonTabSwipeScrollView.contentSize = CGSize(width: width, height: carbonToolbar.frame.height)
    }

    @IBAction func backAction(_ sender: Any) {
        navigateToBack()
    }
}

extension SendViewController: SendByAddressViewControllerDelegate {
    func sendByAddressViewController(_ sendByAddressViewController: SendByAddressViewController, didHeightChanged value: CGFloat) {
        self.contentHeightConstraint.constant = value
        self.scrollView.contentSize = CGSize(width: self.view.bounds.height, height: self.containerView.frame.origin.x + value)
    }
}

protocol SendViewControllerDelegate {
    func sendViewControllerClosed(_ sendViewController: SendViewController)
}
