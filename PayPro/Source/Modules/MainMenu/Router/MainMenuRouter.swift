//
//  MainMenuRouter.swift
//  Infinit
//
//  Created by Infinit on 24/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

class MainMenuRouter: MainMenuRouterProtocol {
    
    var mainRouter: MainRouter?
    
    static func installIntoWindow(mainRouter: MainRouter, window: UIWindow, routers: [TabBarViewProtocol]) -> MainMenuRouterProtocol {
        
        let presenter = MainMenuPresenter()
        let view = MainMenuViewController()
        let router = MainMenuRouter()

        presenter.view = view
        presenter.router = router
        view.presenter = presenter
        router.mainRouter = mainRouter

        var viewControllers = [UIViewController]()

        for router in routers {

            let tabBarItem = UITabBarItem()
            tabBarItem.image = router.tabIcon
           
            tabBarItem.title = router.tabTitle
            let viewController = router.configuredViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.tabBarItem = tabBarItem
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.title = router.tabTitle
            viewControllers.append(navigationController)
        }

        let tabBarController = view
        tabBarController.viewControllers = viewControllers
        tabBarController.selectedIndex = 3
        window.rootViewController = tabBarController

        return router
    }
}
