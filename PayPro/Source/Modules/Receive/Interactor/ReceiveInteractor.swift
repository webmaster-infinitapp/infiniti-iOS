//
//  ReceiveInteractor.swift
//  Infinit
//
//  Created by Infinit on 27/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

class ReceiveInteractor: ReceiveInteractorProtocol {
    
    var presenter: ReceiveInteractorOutputProtocol?
    var dataSource: ReceiveDataSourceProtocol?
    
    func retrievePublicKey() {
        dataSource?.retrievePublicKey(handle: { (onSuccess, data, error) in
            if onSuccess {
                if let publicKey = String(data: data!, encoding: .utf8) {
                    self.presenter?.onRetrievePublicKeySuccess(publicKey: publicKey)
                } else {
                    self.presenter?.onGetPublicKeyError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onGetPublicKeyError(error!)
            }
        })
    }
}
