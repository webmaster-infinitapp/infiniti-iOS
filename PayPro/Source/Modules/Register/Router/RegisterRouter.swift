//
//  RegisterRouter.swift
//  Infinit
//
//  Created by Infinit on 28/6/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class RegisterRouter {
    let mainRouter: MainRouterProtocol
    
    init(mainRouter: MainRouterProtocol) {
        self.mainRouter = mainRouter
    }
}

extension RegisterRouter: RegisterRouterProtocol {
    
    func pushRegisterLoginViewController(from origin: RegisterViewProtocol, params: Codable?) {
        
        let destination = RegisterLoginViewController()
        destination.presenter = (origin.presenter as? RegisterLoginPresenterProtocol)!
        destination.presenter?.registerLoginView = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushOTPViewController(from origin: RegisterViewProtocol, params: Codable?) {
        
        let destination = OTPViewController()
        destination.presenter = (origin.presenter as? RegisterOTPPresenterProtocol)!
        destination.presenter?.registerOTPView = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushUserIdViewController(from origin: RegisterOTPViewProtocol, params: Codable?) {
        
        let destination = UserIdViewController()
        destination.presenter = (origin.presenter as? RegisterUserIdPresenterProtocol)!
        destination.presenter?.registerUserIdView = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushPasswordStep1ViewController(from origin: RegisterUserIdViewProtocol, params: Codable?) {
        
        let destination = PasswordStep1ViewController()
        destination.presenter = (origin.presenter as? RegisterStep1PresenterProtocol)!
        destination.presenter?.registerStep1View = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushPasswordStep2ViewController(from origin: RegisterStep1ViewProtocol, params: Codable?) {
        
        let destination = PasswordStep2ViewController()
        destination.presenter = (origin.presenter as? RegisterStep2PresenterProtocol)!
        destination.presenter?.registerStep2View = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushLoginViewController(from origin: RegisterLoginViewProtocol, params: Codable?) {
        
        let destination = LoginViewController()
        destination.presenter = (origin.presenter as? LoginPresenterProtocol)!
        destination.presenter?.loginView = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func showMainMenuViewController(params: Codable? = nil) {
        mainRouter.showMainMenuViewController(params: params)
    }
    
    func showLoginViewController(params: Codable? = nil) {
        mainRouter.showLoginViewController(params: params)
    }
    
    func showTermsAndConditionsWebsite() {
        if let url = URL(string: EnvironmentConstants.termsAndConditionsURL) {
            UIApplication.shared.openURL(url)
        }
    }
}

extension RegisterRouter {
    
    static func create(with mainRouter: MainRouterProtocol, params: Codable? = nil) -> UIViewController {
        let router = RegisterRouter(mainRouter: mainRouter)
        let dataSource = RegisterDataSource()
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let view = RegisterViewController()
        
        presenter.registerView = view
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        dataSource.output = interactor
        
        return view
    }
    
    static func createLogin(with mainRouter: MainRouterProtocol, params: Codable? = nil) -> UIViewController {
        let router = RegisterRouter(mainRouter: mainRouter)
        let dataSource = RegisterDataSource()
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let view = LoginViewController()
        
        presenter.loginView = view
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        dataSource.output = interactor
        
        return view
    }
}
