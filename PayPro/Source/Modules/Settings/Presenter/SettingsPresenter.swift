//
//  SettingsPresenter.swift
//  Infinit
//
//  Created by Infinit on 2/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SettingsPresenter {
    
    var router: SettingsRouterProtocol?
    var interactor: SettingsInteractorProtocol?
    
    weak var settingsView: SettingsViewProtocol?
    var privateKeyView: SettingsPrivateKeyViewProtocol?
    var passwordView: SettingsPasswordViewProtocol?
    var gasPriceView: SettingsGasPriceViewProtocol?
    var gasLimitView: SettingsGasLimitViewProtocol?
    var infoView: SettingsInfoViewProtocol?
        
    var clientName = ""
    var gasPriceInGweis = ""
    var gasLimit = ""
    var picture = ""
    
    var newPassword = ""
    
    init() { }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    
    func retrieveUserProfile() {
        interactor?.retrieveUserProfile()
    }
    
    func setSettingsView() {
        settingsView?.setUserProfile(clientName: clientName, gasPrice: gasPriceInGweis, gasLimit: gasLimit, image: picture)
    }
    
    func openSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(url!)
    }
    
    func newPhotoChosen(newPhoto: String) {
        interactor?.updatePhoto(newPhoto: newPhoto)
    }
    
    func privateKeysButtonPressed(from: UIViewController) {
        router?.showPrivateKeysViewController(from: from, presenter: self)
    }
    
    func passwordButtonPressed(from: UIViewController) {
        router?.showPasswordViewController(from: from, presenter: self)
    }
    
    func gasPriceButtonPressed(from: UIViewController) {
        router?.showGasPriceViewController(from: from, presenter: self)
    }
    
    func gasLimitButtonPressed(from: UIViewController) {
        router?.showGasLimitViewController(from: from, presenter: self)
    }
    
    func aboutUsButtonPressed() {
        settingsView?.showURL(Urls.aboutUs)
    }
    
    func rateUsButtonPressed() {
        settingsView?.showURL(EnvironmentConstants.termsAndConditionsURL)
    }
    
    func infoButtonPressed(from: UIViewController) {
        router?.showInfoViewController(from: from, presenter: self)
    }
    
    func logOutButtonPressed() {
        settingsView?.onLogOut()
    }
}

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
    func onRetrieveUserProfileSuccess(userProfile: RetrieveUserProfileOutput) {
        self.clientName = userProfile.nombre
        self.gasPriceInGweis = String(userProfile.gasPrice/1000) // Server give us gasPrice and gasLimit in MGweis and we print them in Gweis
        self.gasLimit = String(userProfile.gasLimit)
        self.picture = userProfile.imagen ?? ""
        setSettingsView()
    }
    
    func onUpdatePhotoSuccess(_ newPhoto: String) {
        self.picture = newPhoto.stringToBase64()
        settingsView?.onUpdatePhotoSuccess(newPhoto: newPhoto)
    }
    
    func onUpdatePhotoError(_ error: String) {
        settingsView?.onUpdatePhotoError()
    }
    
    func onRetrievePrivateKeySuccess(_ privateKey: String) {
        privateKeyView?.setPrivateKey(privateKey)
    }
    
    func onRetrievePrivateKeyError(_ error: String) {
        privateKeyView?.showError(error)
    }
    
    func onRetrieveChangePasswordSuccess() {
        let keychainWrapper = KeychainWrapper.standard
        keychainWrapper.addPasswordKeychainWrapper(password: newPassword)
        newPassword = ""
        passwordView?.navigateBackToSettings()
        settingsView?.showToast(NSLocalizedString("settings.changePassword.confirmNewPasswordToast", comment: ""))
    }
    
    func onRetrieveChangePasswordError(_ error: String) {
        passwordView?.showError(error)
    }
    
    func onUpdateGasPriceSuccess(newGasPriceInMweis: String) {
        self.gasPriceInGweis = String(Int(newGasPriceInMweis)! / 1000)
        gasPriceView?.onUpdateGasPriceSuccess()
    }
    
    func onUpdateGasPriceError(_ error: String) {
        gasPriceView?.onUpdateGasPriceError(error: error)
    }
    
    func onUpdateGasLimitSuccess(newGasLimit: String) {
        self.gasLimit = newGasLimit
        gasLimitView?.onUpdateGasLimitSuccess()
    }
    
    func onUpdateGasLimitError(_ error: String) {
        gasLimitView?.onUpdateGasLimitError(error: error)
    }
    
    func onError(_ message: String) {
        settingsView?.onRetrieveUserProfileError(error: message)
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

extension SettingsPresenter: SettingsPrivateKeyPresenterProtocol {
    func confirmPasswordButtonPressed(password: String) {
        let keychainWrapper = KeychainWrapper.standard
        var passwordFromKeychainWrapper: String?
        if let pin: String = keychainWrapper.read(forKey: KeychainValues.KeychainPassKey, reason: "Reason") as? String {
            passwordFromKeychainWrapper = pin
        }
        
        if password.count == 6 {
            if password.stringToBase64() == passwordFromKeychainWrapper {
                privateKeyView?.passwordConfirmed()
            } else {
                privateKeyView?.showError(NSLocalizedString("settings.privateKey.passwordError", comment: ""))
            }
        } else {
            privateKeyView?.showError(NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
        }
    }
    
    func retrievePrivateKey() {
        interactor?.retrievePrivateKey()
    }
    
    func copyPrivateKeyToClipboardButtonPressed() {
        privateKeyView?.copyPrivateKeyToClipboard()
    }
}

extension SettingsPresenter: SettingsPasswordPresenterProtocol {
    func createNewPasswordButtonPressed(_ newPassword: String) {
        let onlyNumbersChecking = newPassword.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        print (onlyNumbersChecking)
        
        if newPassword.count != 6 {
            passwordView?.showError(NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
            self.newPassword = ""
        } else if !(onlyNumbersChecking.count == 6) {
            passwordView?.showError(NSLocalizedString("password.onlyNumbers.ErrorDescription", comment: ""))
            self.newPassword = ""
        } else {
            if self.newPassword == "" {
                self.newPassword = newPassword
                passwordView?.confirmNewPassword()
            } else {
                if newPassword == self.newPassword {
                    self.newPassword = self.newPassword.stringToBase64()
                interactor?.retrieveChangePassword(newPassword.stringToBase64())
                } else {
                    passwordView?.showError(NSLocalizedString("password.notMatching.ErrorDescription", comment: ""))
                    self.newPassword = ""
                }
            }
        }
    }
}

extension SettingsPresenter: SettingsGasPricePresenterProtocol {
    func getGasPrice() -> String {
        return self.gasPriceInGweis
    }
    
    func setGasPrice(gasPrice: String) {
        let intGasPriceInGweis = Int(gasPrice)
        let intGasPriceInMweis = intGasPriceInGweis! * 1000
        interactor?.updateGasPrice(newGasPrice: String(intGasPriceInMweis))
    }
}

extension SettingsPresenter: SettingsGasLimitPresenterProtocol {
    func setGasLimit(gasLimit: String) {
        if gasLimit != "" {
            let gasLimitNumber = Int(gasLimit)
            if gasLimitNumber != 0 {
                interactor?.updateGasLimit(newGasLimit: String(gasLimitNumber!))
            } else {
                gasLimitView?.onUpdateGasLimitError(error: NSLocalizedString("settings.gasLimit.ErrorDescription", comment: ""))
            }
        } else {
            gasLimitView?.onUpdateGasLimitError(error: NSLocalizedString("settings.gasLimit.EmptyTextField", comment: ""))
        }
    }
    
    func getGasLimit() -> String {
        return self.gasLimit
    }
}

extension SettingsPresenter: SettingsInfoPresenterProtocol {
    func termsOfServiceButtonPressed() {
        infoView?.showURL(Urls.termsOfService)
    }
    
    func privacyPolicyButtonPressed() {
        infoView?.showURL(Urls.privacyPolicy)
    }
    
    func websiteButtonPressed() {
        infoView?.showURL(Urls.website)
    }
}
