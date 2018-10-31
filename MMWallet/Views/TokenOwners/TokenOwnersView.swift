//
//  TokenOwnersView.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 28.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class TokenOwnersView: UIView {
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let closeButtonImage = R.image.closeIcon()
            closeButton.setImage(closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            closeButton.tintColor = UIColor(componentType: .popButtonClose)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(R.nib.settingsExportKeyTableViewCell)
        }
    }
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.clipsToBounds = true
            backView.layer.cornerRadius = 14
            backView.backgroundColor = UIColor(componentType: .popBackground)
        }
    }

    var copiedTableViewCell: SettingsExportKeyTableViewCell?
    var copiedPopup: CopiedView?
    
    var assetModel: AssetDetailModel?
    var assetId: Int = 0
    
    func configureView(assetId: Int) {
        self.assetId = assetId

        backViewHeightConstraint.constant = 36 + 25

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.backViewHeightConstraint.constant + 28 + 41)
            self.loadData()
            self.tableView.reloadData()
        }
    }

    func loadData() {
        assetModel = StorageManager.shared.getAssetDetail(id: assetId)

        //backViewHeightConstraint.constant = cell.getHeight() + 36 + 25
        //backViewTopConstraint.constant = self.bounds.height*0.5 - 41*2 -

        calcContentHeight()
    }

    func calcContentHeight() {
        backViewHeightConstraint.constant = CGFloat(assetModel!.owner.count*44 + 36 + 25)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height:  self.backViewHeightConstraint.constant + 28 + 41)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }

    func showCopiedCellMessage(indexCell: Int) {

        let addressString = assetModel!.owner[indexCell].address

        UIPasteboard.general.string = addressString
        if copiedPopup == nil {
            copiedPopup = R.nib.copiedView.firstView(owner: nil)
            self.addSubview(copiedPopup!)
            copiedPopup!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(copiedTableViewCell!.titleLabel).offset(-30)
                make.centerX.equalTo(copiedTableViewCell!.titleLabel)
                make.width.equalTo(136)
                make.height.equalTo(36)
            }
            copiedPopup!.alpha = 0

            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.copiedPopup?.alpha = 1
            }, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.copiedPopup?.alpha = 0
                }) { [weak self] complete in
                    self?.copiedPopup?.removeFromSuperview()
                    self?.copiedPopup = nil
                }
            }
        }
    }
}

extension TokenOwnersView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if assetModel == nil {
            return 0
        }
        return assetModel!.owner.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsExportKeyTableViewCell.identifier, for: indexPath) as! SettingsExportKeyTableViewCell
        let model = assetModel!.owner[indexPath.row]
        cell.applyData(title: model.address, balance: "\(model.balance) \(assetModel!.symbol)")
        return cell
    }
}

extension TokenOwnersView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        copiedTableViewCell = tableView.cellForRow(at: indexPath) as? SettingsExportKeyTableViewCell
        showCopiedCellMessage(indexCell: indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if assetModel == nil {
            return 62
        }
        return 44
    }
}
