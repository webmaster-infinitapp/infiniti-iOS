//
//  SupportViewController.swift
//  Infinit
//
//  Created by Infinit on 31/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SupportViewController: ParentViewController {
    
    var presenter: SupportPresenterProtocol?
    
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var messengerLauncherButton: UIButton!
    
    init(presenter: SupportPresenterProtocol) {
        super.init(nibName: "SupportViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Actions
    
    @IBAction func messengerLauncherDidTouchUpInside(_ sender: UIButton) {
        presenter?.messengerLaucherButtonPressed()
    }
}

extension SupportViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureView() {
        setTextsInLanguage()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setTextsInLanguage() {
        welcomeMessageLabel.text = NSLocalizedString("support.welcomeLabel", comment: "")
        messengerLauncherButton.titleLabel?.text = NSLocalizedString("support.messengerLauncherButton", comment: "")
    }
}

extension SupportViewController: SupportViewProtocol {
}
