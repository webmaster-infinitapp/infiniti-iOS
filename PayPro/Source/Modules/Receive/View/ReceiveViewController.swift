//
//  ReceiveViewController.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class ReceiveViewController: ParentViewController {
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var publicAddressHeaderLabel: UILabel!
    @IBOutlet weak var publicAddressLabel: UILabel!
    
    @IBOutlet var rootView: UIView!
    
    var presenter: ReceivePresenterProtocol?

    init(presenter: ReceivePresenterProtocol) {
        super.init(nibName: "ReceiveViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Actions
    @objc func publicAddressLabelDidTap(sender: UITapGestureRecognizer) {
        presenter?.copyToClipboardButtonPressed(inUIView: rootView)
        UIView.animate(withDuration: 0.3) {
            self.publicAddressLabel.alpha = 0.5
            self.publicAddressLabel.alpha = 1
        }
    }
}

extension ReceiveViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        setTextsInLanguage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setTextsInLanguage() {
        publicAddressHeaderLabel.text = NSLocalizedString("receive.publicAddressHeaderLabel", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingIndicator()
        presenter?.retrievePublicAddress()
    }
}

extension ReceiveViewController: ReceiveViewProtocol {
    func onRetrievePublicKeySuccess(publicKey: String) {
        setQRCodeImage(publicKey: publicKey)
        setPublicAddressLabel(publicKey: publicKey)
        hideLoadingIndicator()
    }
    
    func onRetrievePublicKeyError(_ message: String) {
        hideLoadingIndicator()
        showRetrievePublicKeyError()
    }
    
    private func showRetrievePublicKeyError() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("receive.retrievePublicKeyErrorMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("receive.retrievePublicKeyErrorOkButton", comment: ""), style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.preferredAction = okAction
        self.present(alert, animated: true, completion: nil)
    }
}

extension ReceiveViewController {
    
    private func setQRCodeImage(publicKey: String) {
        qrCodeImage.image = generateQRCodeImage(withPixelSize: qrCodeImage.frame.size, string: publicKey)
    }
    
    private func generateQRCodeImage(withPixelSize pixelSize: CGSize, string: String) -> UIImage {
        let smallQRCodeCIImage = pixelSizeQRGeneration(string: string)
        let resizedImage = resizeQR(ciImage: smallQRCodeCIImage, toPixelSize: pixelSize)
        
        return UIImage(ciImage: resizedImage)
    }
    
    private func pixelSizeQRGeneration(string: String) -> CIImage {
        
        var qrCodeCIImage: CIImage!
        let dataFromString = string.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(dataFromString, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        qrCodeCIImage = filter?.outputImage
        
        return qrCodeCIImage
    }
    
    private func resizeQR(ciImage image: CIImage, toPixelSize pixelSize: CGSize) -> CIImage {
        
        let horizontalScaleFactor = pixelSize.width / image.extent.size.width
        let verticalScaleFactor = pixelSize.height / image.extent.size.height
        
        let transformedImage = image.transformed(by: CGAffineTransform(scaleX: horizontalScaleFactor, y: verticalScaleFactor))
        
        return transformedImage
    }
}

extension ReceiveViewController {
    
    private func setPublicAddressLabel(publicKey: String) {
        publicAddressLabel.attributedText = setPrivateKeyLabelText(publicKey: publicKey)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReceiveViewController.publicAddressLabelDidTap))
        publicAddressLabel.isUserInteractionEnabled = true
        publicAddressLabel.addGestureRecognizer(tap)
    }
    
    private func setPrivateKeyLabelText(publicKey: String) -> NSMutableAttributedString {
        
        let text = NSMutableAttributedString(string: publicKey + "  ")
        let attachmentString = createAttachmenString()
        
        text.append(attachmentString)
        
        return text
    }
    
    private func createAttachmenString() -> NSAttributedString {
        let copyIconAttachement = NSTextAttachment()
        copyIconAttachement.image = UIImage(named: "copyIcon")
        copyIconAttachement.bounds = CGRect(x: 0, y: -5.0, width: 25, height: 25)
        
        let attachementString = NSAttributedString(attachment: copyIconAttachement)
        
        return attachementString
    }
}
