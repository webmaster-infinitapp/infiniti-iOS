//
//  SendProtocols.swift
//  Infinit
//
//  Created by Infinit on 25/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation
import Contacts
import AVFoundation
import Alamofire

protocol SendViewProtocol: class {
    var presenter: SendPresenterProtocol? { get set }
}

protocol SendStep1ViewProtocol: SendViewProtocol {
    func showContactsPermissionAlert()
    func onCheckContactsSuccess(updateWith contacts: [Contact])
    func onCheckContactsError()
}

protocol SendStep2ViewProtocol: SendViewProtocol {
    func showCameraPermissionAlert()
    func showErrorMessage(message: String)
    func printStep2ViewControllerError(message: String)
}

protocol SendStep2QRScannerProtocol: SendViewProtocol {
    func bringCameraNotAvailableToFront()
    func setCameraPreviewLayer(withSession session: AVCaptureSession)
    func showCameraPreviewLayer()
    func setViewFinder()
    func showViewFinder()
    func showWrongQRToast()
}

protocol SendStep3ViewProtocol: SendViewProtocol {
    func onGetTokensListSuccess(tokensList: [RetrieveTokenListOutputData])
    func showTokensError()
    func showErrorMessage(message: String)
    func printStep3ViewControllerError(message: String)
}

protocol SendStep4ViewProtocol: SendViewProtocol {
    
}

protocol SendStep5ViewProtocol: SendViewProtocol {
    func showTransactionError(_ message: String)
}

protocol SendStep6ViewProtocol: SendViewProtocol {
    func onTransactionSuccess()
    func navigateBack()
}

protocol SendRouterProtocol: class {
    
    func showSendStep2ViewController(from: UIViewController, presenter: SendPresenter)
    func showSendStep2QRScannerController(from: UIViewController, presenter: SendPresenter)
    func showSendStep3ViewController(from: UIViewController, presenter: SendPresenter)
    func showSendStep4ViewController(from: UIViewController, presenter: SendPresenter)
    func showSendStep5ViewController(from: UIViewController, presenter: SendPresenter)
    func showSendStep6ViewController(from: UIViewController, presenter: SendPresenter)
    func resetSend(tabBarController: UITabBarController)
}

protocol SendPresenterProtocol: class {
    var view: SendViewProtocol? { get set }
    var router: SendRouterProtocol? { get set }
    var interactor: SendInteractorProtocol? { get set }
    
    func goToSendStep2ViewController(from: UIViewController)
    func goToSendStep2QRScannerController(from: UIViewController)
    func goToSendStep3ViewController(from: UIViewController)
    func goToSendStep4ViewController(from: UIViewController)
    func goToSendStep5ViewController(from: UIViewController)
    func goToSendStep6ViewController(from: UIViewController)
    
    func onTransactionSubmittedViewPressed()
    
    func getAddress() -> String
    func getCurrency() -> String
    func getAmount() -> String
    func getMessage() -> String
    func setAddress(adress: String)
    func setCurrency(currency: String)
    func setAmount(amount: String)
    func setMessage(message: String)
    func getName() -> String
    func setOriginAddress(originAddress: String)
    func getAvailableAmount() -> String
    func setAvailableAmount(availableAmount: String)
    
    func getContacts()
    func isAuthorizedToAccessContacts() -> Bool
    func openSettings()
    func resetAddress()
    func resetName()
    func selectedContact(contact: Contact)
    func scanQRCodeButtonSelected()
    func launchScanner()
    func captureMetadataObjectsFound(objects: [AVMetadataObject])
    func qrCodeFound(withString: String)
    func stopQRScanner()
    func getTokensList()
    func makeTransactionOrTransferToken()
    func transferToken()
    func transaction()
}

protocol SendInteractorProtocol: class {
    var presenter: SendInteractorOutputProtocol? { get set }
    var dataSource: SendDataSourceProtocol? { get set }
    var contactStore: CNContactStore { get set }
    
    func checkContacts(phoneNumbers: [String])
    func getUserContacts() -> [CNMutableContact]
    func getTokensList()
    func transferToken(message: String, amount: Double, address: String, tokenAddress: String)
    func transaction(message: String, amount: Double, address: String)
}

protocol SendInteractorOutputProtocol: class {
    func onCheckContactsSuccess(response: [CheckContactsOutputData])
    func onGetTokensListSuccess(response: [RetrieveTokenListOutputData])
    func onTransferTokenSuccess(response: TransferTokenOutputData)
    func onTransactionSuccess(response: TransactionOutputData)
    func onCheckContactsError(_ message: String)
    func onGetTokensListError(_ message: String)
    func onTransferTokenError(_ message: String)
    func onTransactionError(_ message: String)
    func onTokenExpired()
}

protocol SendDataSourceProtocol: class {
    
    func checkContacts(with parameters: Parameters, handle: @escaping ServiceHandler)
    func getTokensList(handle: @escaping ServiceHandler)
    func transferToken(with parametes: Parameters, handle: @escaping ServiceHandler)
    func transaction(with parameters: Parameters, handle: @escaping ServiceHandler)
}
