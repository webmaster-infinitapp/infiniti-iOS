//
//  AccountRouter.swift
//  Infinit
//
//  Created by Infinit on 9/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

class AccountRouter: TabBarViewProtocol {
    
    var tabIcon: UIImage = UIImage(named: "Account")!
    
    var tabTitle: String = NSLocalizedString("account.tabBarTitle", comment: "")
    
    func configuredViewController() -> UIViewController {
        
        let dataSource = AccountDataSource()
        let interactor = AccountInteractor()
        let presenter = AccountPresenter()
        let view = AccountBalanceViewController()
        
        presenter.balanceView = view
        presenter.router = self
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        
        return view
    }
    
    func configuredTransactionsViewController() -> UIViewController {
        
        let dataSource = AccountDataSource()
        let interactor = AccountInteractor()
        let presenter = AccountPresenter()
        let view = AccountTransactionHistoryViewController()
        
        presenter.transactionView = view
        presenter.router = self
        presenter.interactor = interactor
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        
        return view
    }
}

extension AccountRouter: AccountRouterProtocol {

    func pushAddTokenViewController(from origin: AccountBalanceViewProtocol, params: Codable?) {
        
        let destination = AddTokenViewController()
        destination.presenter = (origin.presenter as? AccountAddTokenPresenterProtocol)!
        destination.presenter?.addTokenView = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushTransactionDetailsViewController(from origin: AccountTransactionHistoryViewProtocol, params: Codable?) {
        
        let destination = TransactionDetailsViewController()
        destination.presenter = (origin.presenter as? AccountTransactionDetailsPresenterProtocol)!
        destination.presenter?.transactionDetailsView = destination
        (origin as? UIViewController)!.navigationController?.pushViewController(destination, animated: true)
    }
    
    func showAccountBalanceViewController(params: Codable?, tabBarController: UITabBarController) {
        
        let navigationController = UINavigationController(rootViewController: configuredViewController())
        placeTabBarItem(in: navigationController)
        tabBarController.viewControllers![3] = navigationController
    }
    
    func showTransactionHistoryViewController(params: Codable?, tabBarController: UITabBarController) {
        
        let navigationController = UINavigationController (rootViewController: configuredTransactionsViewController())
        placeTabBarItem(in: navigationController)
        tabBarController.viewControllers![3] = navigationController
    }
    
    func popView(from origin: AccountAddTokenViewProtocol) {
        
        (origin as? UIViewController)?.navigationController?.popViewController(animated: true)
    }
    
    private func placeTabBarItem(in navigationController: UINavigationController) {
        
        let tabBarItem = UITabBarItem()
        tabBarItem.image = self.tabIcon
        tabBarItem.title = self.tabTitle
        navigationController.tabBarItem = tabBarItem
    }
}
