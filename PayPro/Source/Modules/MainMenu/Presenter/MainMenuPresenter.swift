//
//  MainMenuPresenter.swift
//  Infinit
//
//  Created by Infinit on 24/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

class MainMenuPresenter: MainMenuPresenterProtocol {
    
    weak var view: MainMenuViewProtocol?
    var router: MainMenuRouterProtocol?
    var interactor: MainMenuInteractorProtocol?
    
    init() {}
}
