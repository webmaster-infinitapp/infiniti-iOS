//
//  SupportProtocols.swift
//  Infinit
//
//  Created by Infinit on 31/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

protocol SupportViewProtocol: class {
    var presenter: SupportPresenterProtocol? { get set }
}

protocol SupportPresenterProtocol: class {
    var view: SupportViewProtocol? { get set }
    var router: SupportRouter? { get set }
    var interactor: SupportInteractorProtocol? { get set }
    
    func messengerLaucherButtonPressed()
}

protocol SupportInteractorProtocol: class {
    var presenter: SupportPresenterProtocol? {get set}
}
