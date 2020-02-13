//
//  SendRouter.swift
//  Infinit
//
//  Created by Infinit on 3/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

class SendRouter: TabBarViewProtocol {
    
    //inicializar este UIImage con named: Image
    var tabIcon: UIImage = UIImage(named: "Send")!
    var tabTitle: String = NSLocalizedString("send.tabBarTitle", comment: "")
    
    func configuredViewController() -> UIViewController {
        let presenter = SendPresenter()
        let view = SendStep1ViewController(presenter: presenter)
        let interactor = SendInteractor()
        let dataSource = SendDataSource()
        
        presenter.view = view
        presenter.router = self
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        presenter.sendStep1View = view
        
        return view as UIViewController
    }
}

extension SendRouter: SendRouterProtocol {

    func showSendStep2ViewController(from: UIViewController, presenter: SendPresenter) {
        let viewController = SendStep2ViewController(presenter: presenter)
        presenter.sendStep2View = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSendStep2QRScannerController(from: UIViewController, presenter: SendPresenter) {
        let viewController = SendStep2QRScannerViewController(presenter: presenter)
        presenter.sendStep2QRScannerView = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSendStep3ViewController(from: UIViewController, presenter: SendPresenter) {
        let viewController = SendStep3ViewController(presenter: presenter)
        presenter.sendStep3View = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSendStep4ViewController(from: UIViewController, presenter: SendPresenter) {
        let viewController = SendStep4ViewController(presenter: presenter)
        presenter.sendStep4View = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSendStep5ViewController(from: UIViewController, presenter: SendPresenter) {
        let viewController = SendStep5ViewController(presenter: presenter)
        presenter.sendStep5View = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSendStep6ViewController(from: UIViewController, presenter: SendPresenter) {
        let viewController = SendStep6ViewController(presenter: presenter)
        presenter.sendStep6View = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func resetSend(tabBarController: UITabBarController) {
        let navigationController = UINavigationController (rootViewController: configuredViewController())
        placeTabBarItem(in: navigationController)
        tabBarController.viewControllers![2] = navigationController
    }
    
    private func placeTabBarItem(in navigationController: UINavigationController) {
        let tabBarItem = UITabBarItem()
        tabBarItem.image = self.tabIcon
        tabBarItem.title = self.tabTitle
        navigationController.tabBarItem = tabBarItem
    }
}
