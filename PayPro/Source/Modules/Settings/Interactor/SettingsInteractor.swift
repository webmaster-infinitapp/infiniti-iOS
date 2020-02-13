//
//  SettingsInteractor.swift
//  Infinit
//
//  Created by Infinit on 26/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

class SettingsInteractor: SettingsInteractorProtocol {
    
    var presenter: SettingsInteractorOutputProtocol?
    var dataSource: SettingsDataSourceProtocol?
    
    func retrieveUserProfile() {
        dataSource?.retrieveUserProfile(handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let userProfile = try JSONDecoder().decode(RetrieveUserProfileOutput.self, from: data!)
                    self.presenter?.onRetrieveUserProfileSuccess(userProfile: userProfile)
                } catch {
                    self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onError(error!)
            }
        })
    }
    
    func retrievePrivateKey() {
        dataSource?.retrievePrivateKey(handle: { (onSuccess, data, error) in
            if onSuccess {
                if let privatekey = String(data: data!, encoding: .utf8) {
                    self.presenter?.onRetrievePrivateKeySuccess(privatekey)
                } else {
                    self.presenter?.onRetrievePrivateKeyError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onRetrievePrivateKeyError(error!)
            }
        })
    }
    
    func retrieveChangePassword(_ newPassword: String) {
        dataSource?.retrieveChangePassword(newPassword, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    _ = try JSONDecoder().decode(ServerResponse.self, from: data!)
                    self.presenter?.onRetrieveChangePasswordSuccess()
                } catch {
                    self.presenter?.onRetrieveChangePasswordError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onRetrieveChangePasswordError(error!)
            }
        })
    }
    
    func updateGasPrice(newGasPrice: String) {
        dataSource?.updateGasPrice(gasPrice: newGasPrice, handle: { (onSuccess, data, error) in
            if onSuccess {
                if let newGasPrice = String(data: data!, encoding: .utf8) {
                    self.presenter?.onUpdateGasPriceSuccess(newGasPriceInMweis: newGasPrice)
                } else {
                    self.presenter?.onUpdateGasLimitError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onUpdateGasPriceError(error!)
            }
        })
    }
    
    func updateGasLimit(newGasLimit: String) {
        dataSource?.updateGasLimit(gasLimit: newGasLimit, handle: { (onSuccess, data, error) in
            if onSuccess {
                if let newGasLimit = String(data: data!, encoding: .utf8) {
                    self.presenter?.onUpdateGasLimitSuccess(newGasLimit: newGasLimit)
                } else {
                    self.presenter?.onUpdateGasLimitError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onUpdateGasPriceError(error!)
            }
        })
    }
    
    func updatePhoto(newPhoto: String) {
        dataSource?.updatePhoto(image: newPhoto, handle: { (onSuccess, data, error) in
            if onSuccess {
                if let newPhoto = String(data: data!, encoding: .utf8) {
                    self.presenter?.onUpdatePhotoSuccess(newPhoto)
                } else {
                    self.presenter?.onUpdatePhotoError(NSLocalizedString("settings.updatePhotoError", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onUpdatePhotoError(error!)
            }
        })
    }
}
