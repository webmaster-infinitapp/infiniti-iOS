//
//  ReceiveProtocols.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

protocol ReceiveViewProtocol: class {
    var presenter: ReceivePresenterProtocol? { get set }
    
    func onRetrievePublicKeySuccess(publicKey: String)
    func onRetrievePublicKeyError(_ message: String)
}

protocol ReceivePresenterProtocol: class {
    var view: ReceiveViewProtocol? { get set }
    var router: ReceiveRouter? { get set }
    var interactor: ReceiveInteractorProtocol? { get set }
    
    func retrievePublicAddress()
    func getPublicAddress() -> String?
    func copyToClipboardButtonPressed(inUIView view: UIView)
}

protocol ReceiveInteractorProtocol: class {
    var presenter: ReceiveInteractorOutputProtocol? { get set }
    var dataSource: ReceiveDataSourceProtocol? { get set }
    
    func retrievePublicKey()
}

protocol ReceiveInteractorOutputProtocol: class {
    func onRetrievePublicKeySuccess(publicKey: String)
    func onGetPublicKeyError(_ message: String)
    func onTokenExpired()
}

protocol ReceiveDataSourceProtocol: class {
    func retrievePublicKey(handle: @escaping ServiceHandler)
}
