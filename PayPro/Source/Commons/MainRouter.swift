//
//  MainRouter.swift
//  Infinit
//
//  Created by Infinit on 14/12/2017.
//  Copyright © 2017 Infinit. All rights reserved.
//

import Foundation
import UIKit

protocol MainRouterProtocol {
    func showRegisterViewController(params: Codable?)
    func showLoginViewController(params: Codable?)
    func showMainMenuViewController(params: Codable?)
}

protocol TabBarViewProtocol {
    
    var tabIcon: UIImage { get }
    var tabTitle: String { get }
    
    func configuredViewController() -> UIViewController
}

class MainRouter {
    let window: UIWindow
    var mainMenuRouter: MainMenuRouterProtocol?
    var rootViewController: UIViewController {
        guard let rootViewController = window.rootViewController else {
            fatalError("There is no rootViewController installed on the window")
        }
        return rootViewController
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func presentRootViewController() {
        let keychainWrapper = KeychainWrapper.standard
        if let _ = keychainWrapper.read(forKey: KeychainValues.KeychainUserKey, reason: "Reason") {
            showLoginViewController()
        } else {
            showRegisterViewController()
        }
    }
}

extension MainRouter: MainRouterProtocol {
    
    func showRegisterViewController(params: Codable? = nil) {
        let registerViewController = RegisterRouter.create(with: self, params: params)
        let rootViewController = UINavigationController(rootViewController: registerViewController)
        window.rootViewController = rootViewController
    }
    
    func showLoginViewController(params: Codable? = nil) {
        let loginViewController = RegisterRouter.createLogin(with: self, params: params)
        let rootViewController = UINavigationController(rootViewController: loginViewController)
        window.rootViewController = rootViewController
    }
    
    func showMainMenuViewController(params: Codable? = nil) {
        
        var routers = [TabBarViewProtocol]()
        
        let supportRouter = SupportRouter()
        routers.append(supportRouter)
        
        let receiveRouter = ReceiveRouter()
        routers.append(receiveRouter)
        
        let sendRouter = SendRouter()
        routers.append(sendRouter)
        
        let accountRouter = AccountRouter()
        routers.append(accountRouter)
        
        let settingsRouter = SettingsRouter()
        routers.append(settingsRouter)
        
        self.mainMenuRouter = MainMenuRouter.installIntoWindow(mainRouter: self, window: self.window, routers: routers)
    }
}
