//
//  SendStep2ViewController.swift
//  Infinit
//
//  Created by Infinit on 3/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SendStep2ViewController: SendViewController {
    
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var setAddressManuallyLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var scanQRCodeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    init (presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep2ViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didScanQRCodeButtonTouchUpInside(_ sender: Any) {
        addressTextField.resignFirstResponder()
        presenter?.scanQRCodeButtonSelected()
    }
}

//Cyclelife
extension SendStep2ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressTextField.text = presenter?.getAddress()
        self.navigationItem.title = NSLocalizedString("send.step2.title", comment: "")
    }
    
    private func configureView() {
        setTextsInLanguage()
        selectorView.addAllBordersWithColor(color: CustomColors.bordersColor, width: 1, radius: 3)
        setNextButton()
        addressTextField.delegate = self
        addressTextField.text = presenter?.getAddress()
    }
    
    private func setTextsInLanguage() {
        setAddressManuallyLabel.text = NSLocalizedString("send.step2.setAddressManuallyLabel", comment: "")
        scanQRCodeLabel.text = NSLocalizedString("send.step2.scanQRCodeLabel", comment: "")
        infoLabel.text = NSLocalizedString("send.step2.infoLabel", comment: "")
    }
    
    override func nextButtonPressed() {
        addressTextField.resignFirstResponder()
        if addressTextField.text != "" && addressTextField.text?.hasPrefix("0x") == true {
            presenter?.goToSendStep3ViewController(from: self)
        } else {
            showErrorMessage(message: NSLocalizedString("send.step2.errorDescription.textFieldsNotFilled", comment: ""))
        }
    }
}

extension SendStep2ViewController: SendStep2ViewProtocol {
    
    func showCameraPermissionAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("send.step2QRScanner.allowAccessToCameraAlertMessage", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("send.step2QRScanner.allowAccessToCameraCancelButton", comment: ""), style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: NSLocalizedString("send.step2QRScanner.allowAccessToCameraSettingsButton", comment: ""), style: .default, handler: { (action) in
            self.presenter?.openSettings()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        alert.preferredAction = settingAction
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(message: String) {
        let alertTitle = NSLocalizedString("send.step2.errorDescription.title", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("send.step2.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.printStep2ViewControllerError(message: message)}))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printStep2ViewControllerError(message: String) {
        print("error: \(message)")
    }
}

extension SendStep2ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.setAddress(adress: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        return true
    }
}
