//
//  ReceiveRouter.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

class ReceiveRouter: TabBarViewProtocol {
    
    var tabIcon: UIImage = UIImage(named: "Receive")!
    var tabTitle: String = NSLocalizedString("receive.tabBarTitle", comment: "")
    
    func configuredViewController() -> UIViewController {
        
        let presenter = ReceivePresenter()
        let view = ReceiveViewController(presenter: presenter)
        let interactor = ReceiveInteractor()
        let dataSource = ReceiveDataSource()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = self
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        
        return view as UIViewController
    }
}
