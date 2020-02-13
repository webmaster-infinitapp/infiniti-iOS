//
//  SupportRouter.swift
//  Infinit
//
//  Created by Infinit on 31/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

class SupportRouter: TabBarViewProtocol {
    
    var tabIcon: UIImage = UIImage(named: "Support")!
    var tabTitle: String = NSLocalizedString("support.tabBarTitle", comment: "")
    
    func configuredViewController() -> UIViewController {
        
        let presenter: SupportPresenterProtocol = SupportPresenter()
        let view = SupportViewController(presenter: presenter)
        let interactor: SupportInteractorProtocol = SupportInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = self
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view as UIViewController
    }
}
