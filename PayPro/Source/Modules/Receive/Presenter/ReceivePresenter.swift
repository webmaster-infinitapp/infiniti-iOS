//
//  ReceivePresenter.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class ReceivePresenter {
    
    weak var view: ReceiveViewProtocol?
    var router: ReceiveRouter?
    var interactor: ReceiveInteractorProtocol?
    
    var publicKey: String?
    
    init() {}
}

extension ReceivePresenter: ReceivePresenterProtocol {
    
    func retrievePublicAddress() {
        interactor?.retrievePublicKey()
    }
    
    func getPublicAddress() -> String? {
        return publicKey
    }
    
    func copyToClipboardButtonPressed(inUIView view: UIView) {
        UIPasteboard.general.string = publicKey
        view.showToast(toastMessage: NSLocalizedString("general.copyToClipboard", comment: ""))
    }
}

extension ReceivePresenter: ReceiveInteractorOutputProtocol {
    func onRetrievePublicKeySuccess(publicKey: String) {
        self.publicKey = publicKey
        view?.onRetrievePublicKeySuccess(publicKey: publicKey)
    }
    
    func onGetPublicKeyError(_ message: String) {
        view?.onRetrievePublicKeyError(message)
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
