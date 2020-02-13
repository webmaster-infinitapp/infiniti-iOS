//
//  SupportPresenter.swift
//  Infinit
//
//  Created by Infinit on 31/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import Intercom

class SupportPresenter {
    
    weak var view: SupportViewProtocol?
    var router: SupportRouter?
    var interactor: SupportInteractorProtocol?
    
    init() {}
}

extension SupportPresenter: SupportPresenterProtocol {
    func messengerLaucherButtonPressed() {
        Intercom.presentMessenger()
    }
}
