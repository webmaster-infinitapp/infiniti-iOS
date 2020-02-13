//
//  MainMenuViewController.swift
//  Infinit
//
//  Created by Infinit on 24/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

class MainMenuViewController: UITabBarController {
    
    var presenter: MainMenuPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //presenter?.onViewLoaded()
    }
}

extension MainMenuViewController: MainMenuViewProtocol {
    
    func showErrorMessage(message: String) {
        let alertTitle = NSLocalizedString("register.registerErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
            self.printLoginError(message: message)
        }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printLoginError(message: String) {
        print("error: \(message)")
    }
}
