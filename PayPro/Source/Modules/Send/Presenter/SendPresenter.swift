//
//  SendPresenter.swift
//  Infinit
//
//  Created by Infinit on 3/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import AVFoundation

class SendPresenter {
    
    weak var view: SendViewProtocol?
    var router: SendRouterProtocol?
    var interactor: SendInteractorProtocol?
    
    var userContacts: [CNMutableContact] = []
    var userContactsPhoneNumbers: [String] = []
    var matchedContacts: [Contact] = []
    
    var captureSession: AVCaptureSession?
    
    var sendStep1View: SendStep1ViewController?
    var sendStep2View: SendStep2ViewController?
    var sendStep2QRScannerView: SendStep2QRScannerViewController?
    var sendStep3View: SendStep3ViewController?
    var sendStep4View: SendStep4ViewController?
    var sendStep5View: SendStep5ViewController?
    var sendStep6View: SendStep6ViewController?
    
    var address = ""
    var currency = ""
    var amount = "0.00"
    var message = ""
    var name = ""
    var tokenAddress = ""
    var availableAmount = ""
    
    init() {}
}

struct Contact {
    var userContact: CNMutableContact
    var publicAddress: String
    var isCampaign: Bool
    
    init(userContact: CNMutableContact, cuenta: String, isCampania: Bool) {
        self.userContact = userContact
        self.publicAddress = cuenta
        self.isCampaign = isCampania
    }
}

extension SendPresenter: SendPresenterProtocol {
    
    func goToSendStep2ViewController(from: UIViewController) {
        router?.showSendStep2ViewController(from: from, presenter: self)
    }
    
    func goToSendStep2QRScannerController(from: UIViewController) {
        router?.showSendStep2QRScannerController(from: from, presenter: self)
    }
    
    func goToSendStep3ViewController(from: UIViewController) {
        router?.showSendStep3ViewController(from: from, presenter: self)
    }
    
    func goToSendStep4ViewController(from: UIViewController) {
        router?.showSendStep4ViewController(from: from, presenter: self)
    }
    
    func goToSendStep5ViewController(from: UIViewController) {
        router?.showSendStep5ViewController(from: from, presenter: self)
    }
    func goToSendStep6ViewController(from: UIViewController) {
        router?.showSendStep6ViewController(from: from, presenter: self)
    }
    
    func onTransactionSubmittedViewPressed() {
        if let parentTabBarController = sendStep1View?.parent?.parent as? UITabBarController {
            router?.resetSend(tabBarController: parentTabBarController)
        }
    }

    func getAddress() -> String {
        return self.address
    }
    
    func getCurrency() -> String {
        return self.currency
    }
    
    func getAmount() -> String {
        return self.amount
    }
    
    func getMessage() -> String {
        return self.message
    }
    
    func setAddress(adress: String) {
        self.address = adress
    }
    
    func setCurrency(currency: String) {
        self.currency = currency
    }
    
    func setAmount(amount: String) {
        self.amount = amount
    }
    
    func setMessage(message: String) {
        self.message = message
    }
    
    func setOriginAddress(originAddress: String) {
        self.tokenAddress = originAddress
    }
    
    func getName() -> String {
        return name
    }
    
    func getAvailableAmount() -> String {
        return availableAmount
    }
    
    func setAvailableAmount(availableAmount: String) {
        self.availableAmount = availableAmount
    }
    
    func getContacts() {
        userContacts = []
        userContactsPhoneNumbers = []
        matchedContacts = []
        self.userContacts = interactor!.getUserContacts()
        formatContactsPhoneNumbers()
        extractPhoneNumbers()
        interactor?.checkContacts(phoneNumbers: self.userContactsPhoneNumbers)
    }
    
    private func formatContactsPhoneNumbers() {
        for contact in userContacts {
            let phoneNumberLabel = contact.phoneNumbers[0].label
            let originalPhoneNumber = contact.phoneNumbers[0].value.stringValue
            let formattedPhoneNumber = formatPhoneNumber(phoneNumber: originalPhoneNumber)
            let formattedCNPhoneNumber = CNPhoneNumber(stringValue: formattedPhoneNumber)
            let formattedCNLabeledValue = CNLabeledValue<CNPhoneNumber>(label: phoneNumberLabel, value: formattedCNPhoneNumber)
            contact.phoneNumbers.insert(formattedCNLabeledValue, at: 0)
        }
    }
    
    private func formatPhoneNumber(phoneNumber: String) -> String {
        let onlyDigitsPhoneNumber = phoneNumber.onlyDigits()
        if phoneNumber.hasPrefix("+") {
            return  "+" + onlyDigitsPhoneNumber
        } else if phoneNumber.hasPrefix("00") {
            let phoneNumberWithout00 = String(onlyDigitsPhoneNumber.dropFirst(2))
            return "+" + phoneNumberWithout00
        } else {
            return addCountryCode(to: onlyDigitsPhoneNumber)
        }
    }
    
    private func addCountryCode(to phoneNumber: String) -> String {
        let countryCode = Locale.current.countryCallingCode
        return "+" + countryCode + phoneNumber
    }
    
    private func extractPhoneNumbers() {
        for contact in userContacts {
            userContactsPhoneNumbers.append(contact.phoneNumbers[0].value.stringValue)
        }
    }
    
    func isAuthorizedToAccessContacts() -> Bool {
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            return true
        } else {
            return false
        }
    }
    
    func openSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(url!)
    }
    
    func resetAddress() {
        self.address = ""
    }
    
    func resetName() {
        self.name = ""
    }
    
    func selectedContact(contact: Contact) {
        self.address = contact.publicAddress
        self.name = contact.userContact.givenName + " " + contact.userContact.familyName
    }
    
    func scanQRCodeButtonSelected() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {granted in}
        case .authorized:
            goToSendStep2QRScannerController(from: sendStep2View!)
        case .denied:
            sendStep2View?.showCameraPermissionAlert()
        case .restricted:
            goToSendStep2QRScannerController(from: sendStep2View!)
        }
    }
    
    func launchScanner() {
        let camera = getCamera()
        if camera == nil {
            sendStep2QRScannerView!.bringCameraNotAvailableToFront()
        } else {
            do {
                captureSession = AVCaptureSession()
                let input = try AVCaptureDeviceInput(device: camera!)
                captureSession?.addInput(input)
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(sendStep2QRScannerView, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
                sendStep2QRScannerView!.setCameraPreviewLayer(withSession: captureSession!)
                sendStep2QRScannerView!.showCameraPreviewLayer()
                sendStep2QRScannerView!.setViewFinder()
                sendStep2QRScannerView!.showViewFinder()
                captureSession?.startRunning()
            } catch {}
        }
    }
    
    private func getCamera() -> AVCaptureDevice? {
        for device in AVCaptureDevice.devices() {
            if device.hasMediaType(AVMediaType.video) && device.position == .back {
                return device
            }
        }
        return nil
    }
    
    func captureMetadataObjectsFound(objects: [AVMetadataObject]) {
        if objects.count != 0 {
            let metadataObj = objects[0] as? AVMetadataMachineReadableCodeObject
            if metadataObj!.type == AVMetadataObject.ObjectType.qr {
                if metadataObj!.stringValue != nil {
                    if metadataObj!.stringValue != "" && metadataObj!.stringValue!.hasPrefix("0x") {
                        qrCodeFound(withString: metadataObj!.stringValue!)
                        captureSession?.stopRunning()
                    } else {
                        sendStep2QRScannerView?.showWrongQRToast()
                    }
                }
            }
        }
    }
    
    func qrCodeFound(withString qrString: String) {
        address = qrString
        goToSendStep3ViewController(from: sendStep2QRScannerView!)
    }
    
    func stopQRScanner() {
        captureSession?.stopRunning()
    }
    
    func getTokensList() {
        interactor?.getTokensList()
    }
    
    func makeTransactionOrTransferToken() {
        let currencySymbol = getCurrencySymbol(currencyString: self.currency)
        if currencySymbol == "ETH" {
            transaction()
        } else {
            transferToken()
        }
    }
    
    private func getCurrencySymbol(currencyString: String) -> String {
        let colonIndex = (currencyString.range(of: "(", options: .backwards)?.lowerBound)!
        let indexAfterColon = currencyString.index(after: colonIndex)
        var currency = currencyString.suffix(from: indexAfterColon)
        currency = currency.prefix(currencyString.count - 2)
        currency = currency.dropLast()
        return String(currency)
    }
    
    func transferToken() {
        let convertedAmountDouble = (self.amount as NSString).doubleValue
        interactor?.transferToken(message: self.message, amount: convertedAmountDouble, address: self.address, tokenAddress: self.tokenAddress)
    }
    
    func transaction() {
        let convertedAmount = (self.amount as NSString).doubleValue
        interactor?.transaction(message: self.message, amount: convertedAmount, address: self.address)
    }
}

extension SendPresenter: SendInteractorOutputProtocol {
    
    func onCheckContactsSuccess(response: [CheckContactsOutputData]) {
        matchUserContacts(with: response)
        sendStep1View?.onCheckContactsSuccess(updateWith: matchedContacts)
    }
    
    private func matchUserContacts(with payProContacts: [CheckContactsOutputData]) {
        for payProContact in payProContacts {
            if payProContact.isCampania! {
                appendCampaniaToMatchedContacts(payProContact)
            } else {
                let filteredContacts = userContacts.filter {$0.phoneNumbers[0].value.stringValue == payProContact.telefono}
                if !filteredContacts.isEmpty {
                    appendContactToMatchedContacts(payProContact: payProContact, userContact: filteredContacts[0])
                }
            }
        }
    }
    
    private func appendCampaniaToMatchedContacts(_ campania: CheckContactsOutputData) {
        let campaniaCnContact = CNMutableContact()
        campaniaCnContact.givenName = campania.cuenta!
        campaniaCnContact.phoneNumbers.append(CNLabeledValue(label: "phoneNumber", value: CNPhoneNumber(stringValue: campania.telefono!)))
        let campaniaContact = Contact(userContact: campaniaCnContact, cuenta: campania.telefono!, isCampania: true)
        matchedContacts.insert(campaniaContact, at: matchedContacts.startIndex)
    }
    
    private func appendContactToMatchedContacts(payProContact: CheckContactsOutputData, userContact: CNMutableContact) {
        let newContact = Contact(userContact: userContact, cuenta: payProContact.cuenta!, isCampania: payProContact.isCampania!)
        matchedContacts.append(newContact)
    }
    
    func onCheckContactsError(_ message: String) {
        sendStep1View?.onCheckContactsError()
    }
    
    func onGetTokensListSuccess(response: [RetrieveTokenListOutputData]) {
        sendStep3View!.onGetTokensListSuccess(tokensList: response)
    }
    
    func onGetTokensListError(_ message: String) {
        sendStep3View!.showTokensError()
    }
    
    func onTransferTokenSuccess(response: TransferTokenOutputData) {
        if let error = response.mensajeError {
            sendStep6View?.navigateBack()
            sendStep5View?.showTransactionError(error)
        } else {
            sendStep6View!.onTransactionSuccess()
        }
    }
    
    func onTransferTokenError(_ message: String) {
        sendStep6View?.navigateBack()
        sendStep5View?.showTransactionError(message)
    }
    
    func onTransactionSuccess(response: TransactionOutputData) {
        if let error = response.mensajeError {
            sendStep6View?.navigateBack()
            sendStep5View?.showTransactionError(error)
        } else {
            sendStep6View!.onTransactionSuccess()
        }
    }
    
    func onTransactionError(_ message: String) {
        sendStep6View?.navigateBack()
        sendStep5View?.showTransactionError(message)
    }
    
    func onTokenExpired() {
        if let topController = UIApplication.topViewController() {
            topController.hideLoadingIndicator()
            
            let alertTitle = NSLocalizedString("register.sessionExpiredTitle", comment: "")
            let alertMessage = NSLocalizedString("general.sessionExpiredError", comment: "")
            let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
                (UIApplication.shared.delegate as? AppDelegate)!.presentRootViewController()
            }))
            alert.view.tintColor = CustomColors.grayLabels
            topController.present(alert, animated: true, completion: nil)
        }
    }
}
