//
//  SettingsRouter.swift
//  Infinit
//
//  Created by Infinit on 2/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

class SettingsRouter: TabBarViewProtocol {
    
    //inicializar este UIImage con named: Image
    var tabIcon: UIImage = UIImage(named: "Settings")!
    var tabTitle: String = NSLocalizedString("settings.tabBarTitle", comment: "")
        
    func configuredViewController() -> UIViewController {
        let router = SettingsRouter()
        let dataSource = SettingsDataSource()
        let interactor = SettingsInteractor()
        let presenter =  SettingsPresenter()
        let view = SettingsViewController(presenter: presenter)
        
        presenter.router = router
        presenter.settingsView = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        
        return view as UIViewController
    }
}

extension SettingsRouter: SettingsRouterProtocol {
    
    func showPrivateKeysViewController(from: UIViewController, presenter: SettingsPresenter) {
        let viewController = PrivateKeyViewController(presenter: presenter)
        presenter.privateKeyView = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showPasswordViewController(from: UIViewController, presenter: SettingsPresenter) {
        let viewController = PasswordViewController(presenter: presenter)
        presenter.passwordView = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showGasPriceViewController(from: UIViewController, presenter: SettingsPresenter) {
        let viewController = GasPriceViewController(presenter: presenter)
        presenter.gasPriceView = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showGasLimitViewController(from: UIViewController, presenter: SettingsPresenter) {
        let viewController = GasLimitViewController(presenter: presenter)
        presenter.gasLimitView = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showInfoViewController(from: UIViewController, presenter: SettingsPresenter) {
        let viewController = InfoViewController(presenter: presenter)
        presenter.infoView = viewController
        from.navigationController?.pushViewController(viewController, animated: true)
    }
}
