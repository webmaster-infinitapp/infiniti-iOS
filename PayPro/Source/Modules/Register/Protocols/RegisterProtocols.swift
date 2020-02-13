//
//  LoginProtocols.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

protocol RegisterViewProtocol: class {
    var presenter: RegisterPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol RegisterPresenterProtocol: class {
    var registerView: RegisterViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onCreateAccountButtonClicked(username: String, countryCode: String, telephoneNumber: String)
    func onSignInButtonClicked()
    func onTermsAndConditionsButtonClicked()
}

protocol RegisterLoginViewProtocol: class {
    var presenter: RegisterLoginPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol RegisterLoginPresenterProtocol: class {
    var registerLoginView: RegisterLoginViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onLoginNextButtonClicked(username: String?)
    func onTermsAndConditionsButtonClicked()
}

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol LoginPresenterProtocol: class {
    var loginView: LoginViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onLoginDoneButtonClicked(password: String)
    func onSwitchAccountClicked()
}

protocol RegisterOTPViewProtocol: class {
    var presenter: RegisterOTPPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol RegisterOTPPresenterProtocol: class {
    var registerOTPView: RegisterOTPViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onOTPDoneButtonClicked(otp: String)
}

protocol RegisterUserIdViewProtocol: class {
    var presenter: RegisterUserIdPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol RegisterUserIdPresenterProtocol: class {
    var registerUserIdView: RegisterUserIdViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onUserIdDoneButtonClicked(userId: String)
}

protocol RegisterStep1ViewProtocol: class {
    var presenter: RegisterStep1PresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol RegisterStep1PresenterProtocol: class {
    var registerStep1View: RegisterStep1ViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onPasswordStep1DoneButtonClicked(password: String)
}

protocol RegisterStep2ViewProtocol: class {
    var presenter: RegisterStep2PresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func removeLoadingIndicator()
}

protocol RegisterStep2PresenterProtocol: class {
    var registerStep2View: RegisterStep2ViewProtocol? { get set }
    var interactor: RegisterInteractorProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func onPasswordStep2DoneButtonClicked(password: String)
}

protocol RegisterInteractorProtocol: class {
    var presenter: RegisterInteractorOutputProtocol? { get set }
    var dataSource: RegisterDataSourceProtocol? { get set }
    
    func requestRegisterApp()
    func requestOTP(username: String, telephoneNumber: String, countryCode: String)
    func checkUserId(userId: String)
    func requestSignInWithOTP(otp: String)
    func requestSignInWithPassword(userId: String, username: String, codPais: String, telephone: String, password: String)
    func requestLogin(username: String, password: String)
    func registerUserOnIntercom(withId userId: String)
}

protocol RegisterInteractorOutputProtocol: class {
    func onRegisterAppSuccess()
    func onRequestOTPSuccess()
    func onCheckUserIdSuccess()
    func onRequestSignInWithOTPSuccess()
    func onRequestSignInWithPasswordSuccess()
    func onLoginSuccess()
    func onError(_ message: String)
    func onLoginError(_ message: String)
}

protocol RegisterDataSourceProtocol: class {
    var output: RegisterDataSourceOutputProtocol? { get set }
    
    func registerApp(with parameters: Parameters, handle: @escaping LoginServiceHandler)
    func requestOTP(with parameters: Parameters, handle: @escaping ServiceHandler)
    func checkUserId(userId: String, handle: @escaping ServiceHandler)
    func signInWithOTP(otp: String, handle: @escaping ServiceHandler)
    func registerWithPassword(with parameters: Parameters, handle: @escaping ServiceHandler)
    func login(with parameters: Parameters, handle: @escaping LoginServiceHandler)
}

protocol RegisterDataSourceOutputProtocol: class {
    func onError(_ error: Error)
}

protocol RegisterRouterProtocol: class {
    func pushRegisterLoginViewController(from origin: RegisterViewProtocol, params: Codable?)
    func pushOTPViewController(from origin: RegisterViewProtocol, params: Codable?)
    func pushUserIdViewController(from origin: RegisterOTPViewProtocol, params: Codable?)
    func pushPasswordStep1ViewController(from origin: RegisterUserIdViewProtocol, params: Codable?)
    func pushPasswordStep2ViewController(from origin: RegisterStep1ViewProtocol, params: Codable?)
    func pushLoginViewController(from origin: RegisterLoginViewProtocol, params: Codable?)
    func showLoginViewController(params: Codable?)
    func showMainMenuViewController(params: Codable?)
}
