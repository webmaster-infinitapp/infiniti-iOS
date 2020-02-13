//
//  RegisterPresenter.swift
//  Infinit
//
//  Created by Infinit on 28/6/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class RegisterPresenter {
    
    weak var registerView: RegisterViewProtocol?
    weak var registerLoginView: RegisterLoginViewProtocol?
    weak var registerOTPView: RegisterOTPViewProtocol?
    weak var registerUserIdView: RegisterUserIdViewProtocol?
    weak var registerStep1View: RegisterStep1ViewProtocol?
    weak var registerStep2View: RegisterStep2ViewProtocol?
    weak var loginView: LoginViewProtocol?
    var interactor: RegisterInteractorProtocol?
    var router: RegisterRouterProtocol?
    
    var uncheckedPassword: String?
    var uncheckedUsername: String?
    var uncheckedCountryCode: String?
    var uncheckedTelephone: String?
    var uncheckedUserId: String?
    
    func onTermsAndConditionsButtonClicked() {
        if let url = URL(string: Urls.termsOfService) {
            UIApplication.shared.openURL(url)
        }
    }
}

extension RegisterPresenter: RegisterPresenterProtocol {
    
    func onCreateAccountButtonClicked(username: String, countryCode: String, telephoneNumber: String) {
        uncheckedUsername = username
        uncheckedTelephone = "\(countryCode)\(telephoneNumber)"
        uncheckedCountryCode = countryCode
        
        if username == "" || countryCode == "" || telephoneNumber == "" {
            onError(NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
        } else if !countryCodeHasValidFormat(code: countryCode) {
            onError(NSLocalizedString("register.registerErrorDescription.invalidCountryCode", comment: ""))
        } else if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: telephoneNumber)) {
            onError(NSLocalizedString("register.registerErrorDescription.invalidTelephoneNumber", comment: ""))
        } else if username != "" && countryCodeHasValidFormat(code: countryCode) && telephoneNumber != "" {
        interactor?.requestRegisterApp()
        }
    }
    
    func onSignInButtonClicked() {
        router?.pushRegisterLoginViewController(from: registerView ?? RegisterViewController(), params: nil)
    }
    
    private func countryCodeHasValidFormat(code: String) -> Bool {
        let numberOfDashes = code.components(separatedBy: "-").count - 1
        
        if code.hasPrefix("+") && code.lastIndex(of: "+") == code.startIndex {
            if numberOfDashes <= 1 && code.count == code.onlyDigits().count + 1 + numberOfDashes {
                return true
            }
        }
        return false
    }
}

extension RegisterPresenter: RegisterOTPPresenterProtocol {
    
    func onOTPDoneButtonClicked(otp: String) {
        if otp.count == 4 {
            interactor?.requestSignInWithOTP(otp: otp)
        } else {
            onError(NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
        }
    }
}

extension RegisterPresenter: RegisterUserIdPresenterProtocol {
    
    func onUserIdDoneButtonClicked(userId: String) {
        uncheckedUserId = userId
        interactor?.checkUserId(userId: userId)
    }
}

extension RegisterPresenter: RegisterStep1PresenterProtocol {
    
    func onPasswordStep1DoneButtonClicked(password: String) {
        let onlyNumbersChecking = password.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        print (onlyNumbersChecking)
        
        if password.count < 6 {
            onError(NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
        } else if !(onlyNumbersChecking.count == 6) {
            onError(NSLocalizedString("password.onlyNumbers.ErrorDescription", comment: ""))
        } else {
            uncheckedPassword = password.stringToBase64()
            router?.pushPasswordStep2ViewController(from: registerStep1View ?? PasswordStep1ViewController(), params: nil)
        }
    }
}

extension RegisterPresenter: RegisterStep2PresenterProtocol {
    
    func onPasswordStep2DoneButtonClicked(password: String) {
        if password.stringToBase64() == uncheckedPassword {
            interactor?.requestSignInWithPassword(userId: uncheckedUserId!, username: uncheckedUsername!, codPais: uncheckedCountryCode!, telephone: uncheckedTelephone!, password: uncheckedPassword!)
        } else {
            onError(NSLocalizedString("password.notMatching.ErrorDescription", comment: ""))
        }
    }
}

extension RegisterPresenter: RegisterLoginPresenterProtocol {
    
    func onLoginNextButtonClicked(username: String?) {
        self.uncheckedUserId = username
        if username != "" {
            router?.pushLoginViewController(from: registerLoginView ?? RegisterLoginViewController(), params: nil)
        } else {
            onError(NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
        }
    }
}

extension RegisterPresenter: LoginPresenterProtocol {
    
    func onLoginDoneButtonClicked(password: String) {
        uncheckedPassword = password.stringToBase64()
        if password.count == 6 {
//            interactor?.requestLogin(username: uncheckedUserId ?? UserDefaults.userId!, password: password.stringToBase64())
            let keychainWrapper = KeychainWrapper.standard
            if let userId: String = keychainWrapper.read(forKey: KeychainValues.KeychainUserKey, reason: "Reason") as? String {
                interactor?.requestLogin(username: userId, password: password.stringToBase64())
            } else {
                interactor?.requestLogin(username: uncheckedUserId!, password: password.stringToBase64())
            }
//            guard let userId: String = keychainWrapper.read(forKey: KeychainValues.KeychainUserKey, reason: "Reason") as? String else {
//                return
//            }
        } else {
            loginView?.removeLoadingIndicator()
            loginView?.showErrorMessage(message: NSLocalizedString("password.fieldsNotFilled.errorDescription", comment: ""))
        }
    }
    
    func onSwitchAccountClicked() {
        let keychainWrapper = KeychainWrapper.standard
        let statusUser = keychainWrapper.delete(forKey: KeychainValues.KeychainUserKey)
        print ("Deleted user status: \(statusUser)")
        (UIApplication.shared.delegate as? AppDelegate)!.presentRootViewController()
    }
}

extension RegisterPresenter: RegisterInteractorOutputProtocol {
    
    func onRegisterAppSuccess() {
        if let _ = uncheckedUsername {
            interactor?.requestOTP(username: uncheckedUsername!, telephoneNumber: uncheckedTelephone!, countryCode: uncheckedCountryCode!)
        }
    }
    
    func onRequestOTPSuccess() {
        registerView?.removeLoadingIndicator()
        router?.pushOTPViewController(from: registerView ?? RegisterViewController(), params: nil)
    }
    
    func onRequestSignInWithOTPSuccess() {
        registerOTPView?.removeLoadingIndicator()
        loginView?.removeLoadingIndicator()
        router?.pushUserIdViewController(from: registerOTPView ?? OTPViewController(), params: nil)
    }
    
    func onCheckUserIdSuccess() {
        registerUserIdView?.removeLoadingIndicator()
        router?.pushPasswordStep1ViewController(from: registerUserIdView ?? UserIdViewController(), params: nil)
    }
    
    func onRequestSignInWithPasswordSuccess() {
        registerStep2View?.removeLoadingIndicator()
        let keychainWrapper = KeychainWrapper.standard
        keychainWrapper.addUserKeyKeychainWrapper(user: uncheckedUserId)
        keychainWrapper.addPasswordKeychainWrapper(password: uncheckedPassword)
        
        interactor?.registerUserOnIntercom(withId: uncheckedUserId!)
        
        if let userId: String = keychainWrapper.read(forKey: KeychainValues.KeychainUserKey, reason: "Reason") as? String, let pin: String = keychainWrapper.read(forKey: KeychainValues.KeychainPassKey, reason: "Reason") as? String {
            interactor?.requestLogin(username: userId, password: pin)
        }
    }
    
    func onLoginSuccess() {
        loginView?.removeLoadingIndicator()
        
        let keychainWrapper = KeychainWrapper.standard
        
        uncheckedUserId != nil ? keychainWrapper.addUserKeyKeychainWrapper(user: uncheckedUserId) : nil
        
        if let _ = keychainWrapper.read(forKey: KeychainValues.KeychainPassKey, reason: "Reason") {
            print ("There's already a password")
        } else {
            keychainWrapper.addPasswordKeychainWrapper(password: uncheckedPassword)
            print ("Added password")
        }
        
        if let userId: String = keychainWrapper.read(forKey: KeychainValues.KeychainUserKey, reason: "Reason") as? String {
            interactor?.registerUserOnIntercom(withId: userId)
        } else {
            interactor?.registerUserOnIntercom(withId: uncheckedUserId!)
        }
        router?.showMainMenuViewController(params: nil)
    }
    
    func onError(_ message: String) {
        let topView = (registerView as? UIViewController)?.navigationController?.topViewController
        if let topView = topView as? RegisterStep2ViewProtocol {
            topView.showErrorMessage(message: message)
            topView.removeLoadingIndicator()
        } else if let topView = topView as? RegisterStep1ViewProtocol {
            topView.showErrorMessage(message: message)
        } else if let topView = topView as? RegisterLoginViewProtocol {
            topView.showErrorMessage(message: message)
            topView.removeLoadingIndicator()
        } else if let topView = topView as? RegisterOTPViewProtocol {
            topView.showErrorMessage(message: message)
            topView.removeLoadingIndicator()
        } else if let topView = topView as? RegisterUserIdViewProtocol {
            topView.showErrorMessage(message: message)
            topView.removeLoadingIndicator()
        } else if let topView = topView as? RegisterViewProtocol {
                topView.showErrorMessage(message: message)
                topView.removeLoadingIndicator()
        }
    }
    
    func onLoginError(_ message: String) {
        loginView?.showErrorMessage(message: message)
        loginView?.removeLoadingIndicator()
    }
}
