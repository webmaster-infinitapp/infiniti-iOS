//
//  SendStep2QRScannerViewController.swift
//  Infinit
//
//  Created by Infinit on 14/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SendStep2QRScannerViewController: SendViewController {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var previousOrientation: UIInterfaceOrientation? = .portrait

    var defaultNavigationBarTintColor: UIColor?
    var defaultTextAttributes: [NSAttributedString.Key: Any]?
    var defaultRightBarButtonItemTintColor: UIColor?
    
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var cameraNotAvailableLabel: UILabel!
    @IBOutlet weak var viewFinder: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep2QRScannerViewController", bundle: nil)
        defaultNavigationBarTintColor = navigationController?.navigationBar.barTintColor
        defaultTextAttributes = navigationController?.navigationBar.titleTextAttributes
        defaultRightBarButtonItemTintColor = navigationItem.rightBarButtonItem?.tintColor
        
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SendStep2QRScannerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextsInLanguage()
    }
    
    func setTextsInLanguage() {
        self.navigationItem.title = NSLocalizedString("send.step2QRScanner.title", comment: "")
        self.cameraNotAvailableLabel.text = NSLocalizedString("send.step2QRScanner.cameraNotAvailable", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.launchScanner()
    }
    
    private func configureView() {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1508937776, green: 0.2068715394, blue: 0.2651159167, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.stopQRScanner()
        self.tabBarController?.tabBar.isHidden = false
        previousOrientation = UIApplication.shared.statusBarOrientation
        navigationController?.navigationBar.barTintColor = defaultNavigationBarTintColor
        navigationController?.navigationBar.titleTextAttributes = defaultTextAttributes
        navigationItem.rightBarButtonItem?.tintColor = defaultRightBarButtonItemTintColor
    }
}

extension SendStep2QRScannerViewController: SendStep2QRScannerProtocol {
    
    func bringCameraNotAvailableToFront() {
        view.bringSubviewToFront(cameraNotAvailableLabel)
    }
    
    func setCameraPreviewLayer(withSession session: AVCaptureSession) {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer!.connection?.videoOrientation = transformOrientation(orientation: UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
        setCameraPreviewLayerSize()
    }
    
    private func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    private func setCameraPreviewLayerSize() {
        if UIApplication.shared.statusBarOrientation != previousOrientation {
            let newWidth = scannerView.frame.size.width
            let newHeight = scannerView.frame.size.height
            let newSize = CGSize(width: newHeight, height: newWidth)
            videoPreviewLayer!.frame.size = newSize
        } else {
            videoPreviewLayer!.frame.size = scannerView.frame.size
        }
    }
    
    func showCameraPreviewLayer() {
        scannerView.layer.addSublayer(videoPreviewLayer!)
    }
    
    func setViewFinder() {
        viewFinder.layer.borderColor = UIColor.white.cgColor
        viewFinder.layer.borderWidth = 2
    }
    
    func showViewFinder() {
        scannerView.bringSubviewToFront(viewFinder)
    }
    
    func showWrongQRToast() {
        view.showToast(toastMessage: "This QR doesn't contain a valid beneficiary address")
    }
}

extension SendStep2QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        presenter?.captureMetadataObjectsFound(objects: metadataObjects)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if videoPreviewLayer != nil {
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.videoPreviewLayer!.connection!.videoOrientation = self.transformOrientation(orientation: UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
                self.videoPreviewLayer!.frame.size = self.scannerView.frame.size
            }, completion: { (context) -> Void in
                
            })
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
