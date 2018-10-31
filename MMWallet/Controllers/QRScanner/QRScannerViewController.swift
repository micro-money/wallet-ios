//
//  QRScannerViewController.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 08.08.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: BaseViewController, Messageable, Loadable {

    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]

    var isShowAllert = false

    var delayTimer: Timer?

    var sendViewController: SendViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMask()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        isShowAllert = false
        stopDelay()
        setupScanner()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopScanner()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func configureView(isRefresh: Bool) {

    }

    func createMask() {

        let maskLayer = CAShapeLayer()
        maskLayer.frame = fadeView.bounds
        maskLayer.fillColor = UIColor.black.cgColor

        let path = UIBezierPath(rect: UIScreen.main.bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        let rect = fadeView.convert(maskView.bounds, from: maskView)
        path.append(UIBezierPath(roundedRect: rect, cornerRadius: 15))
        maskLayer.path = path.cgPath
        fadeView.layer.mask = maskLayer
    }

    func setupScanner() {

        captureSession = AVCaptureSession()

        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)

            captureSession!.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession!.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        } catch {
            print(error)
            return
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        captureSession?.startRunning()

        view.bringSubviewToFront(fadeView)
        view.bringSubviewToFront(maskView)
        view.bringSubviewToFront(infoLabel)
    }

    func startDelay() {
        delayTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stopDelay), userInfo: nil, repeats: false)
    }

    @objc func stopDelay() {
        if delayTimer != nil {
            delayTimer?.invalidate()
            delayTimer = nil
        }
    }

    func stopScanner() {

        captureSession?.stopRunning()

        if let inputs = captureSession?.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession?.removeInput(input)
            }
        }

        videoPreviewLayer?.removeFromSuperlayer()
        videoPreviewLayer = nil
        captureSession = nil
    }

    func analyzeCode(codeString: String) {

        if isShowAllert {
            return
        }

        if delayTimer != nil {
            return
        }

        isShowAllert = true
        self.showLoader()
        DataManager.shared.checkAddress(address: codeString) { [weak self] (currencyString, error) in
            if error == nil {
                self?.hideLoaderSuccess() { [weak self] in
                    if currencyString != nil {
                        if let asset = DataManager.shared.getFirstAsset(currency: currencyString!) {
                            //self?.stopScanner()
                            self?.isShowAllert = true
                            self?.stopDelay()
                            self?.sendViewController = self?.navigateToSendModal(assetsId: asset.id, address: codeString)
                            self?.sendViewController?.delegate = self
                            return
                        }
                    }
                    self?.showSorryAlert()
                }
            } else {
                self?.hideLoaderFailure(errorLabelTitle: "Check address failed", errorLabelMessage: "Unknown Error")
                self?.startDelay()
            }
        }
    }

    func showSorryAlert() {
        let errorAlert = UIAlertController(title: nil, message: "Sorry, we can't recognize this QR-code", preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (action:UIAlertAction!) in
            self?.isShowAllert = false
        })

        self.present(errorAlert, animated: true)
        isShowAllert = true
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if metadataObjects.count == 0 {
            //qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject


        if supportedCodeTypes.contains(metadataObj.type) {
            //let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            //qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                analyzeCode(codeString: metadataObj.stringValue!)
            }
        }
    }

}

extension QRScannerViewController: SendViewControllerDelegate {
    func sendViewControllerClosed(_ sendViewController: SendViewController) {
        isShowAllert = false
        stopDelay()
    }
}
