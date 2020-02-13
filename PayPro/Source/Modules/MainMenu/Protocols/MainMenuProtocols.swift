//
//  MainMenuProtocols.swift
//  Infinit
//
//  Created by Infinit on 24/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

protocol MainMenuViewProtocol: class {
    var presenter: MainMenuPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
}

protocol MainMenuPresenterProtocol: class {
    var view: MainMenuViewProtocol? { get set }
    var interactor: MainMenuInteractorProtocol? { get set }
    var router: MainMenuRouterProtocol? { get set }
    
    //func onViewLoaded()
}

protocol MainMenuRouterProtocol: class {
    static func installIntoWindow(mainRouter: MainRouter, window: UIWindow, routers: [TabBarViewProtocol]) -> MainMenuRouterProtocol
    var mainRouter: MainRouter? { get set }
}

protocol MainMenuInteractorProtocol: class {
    var presenter: MainMenuInteractorOutputProtocol? { get set }
    var dataSource: MainMenuDataSourceProtocol? { get set }
    
    func requestLogin(username: String, password: String)
    func registerUserOnIntercom(withId userId: String)
}

protocol MainMenuInteractorOutputProtocol: class {
    func onLoginError(_ message: String)
}

protocol MainMenuDataSourceProtocol: class {
    var output: MainMenuDataSourceOutputProtocol? { get set }
    
    func login(with parameters: Parameters)
}

protocol MainMenuDataSourceOutputProtocol: class {
    func onLoginError(_ error: Error)
    func onLoginSuccess()
}
