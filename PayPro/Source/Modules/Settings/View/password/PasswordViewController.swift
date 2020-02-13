//
//  passwordViewController.swift
//  Infinit
//
//  Created by Infinit on 30/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class PasswordViewController: ParentViewController {
    
    let presenter: SettingsPasswordPresenterProtocol
    
    @IBOutlet weak var passwordView: PasswordView!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    
    var newPassword = ""
    
    init (presenter: SettingsPasswordPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "PasswordViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Buttons Actions
  
    @IBAction func didCreateNewPasswordButtonTouchUpInside(_ sender: Any) {
        passwordFinishedEnter()
    }
    
    @IBAction func onScreenPressed(_ sender: Any) {
        if passwordView.isFirstResponder {
            _ = passwordView.resignFirstResponder()
        } else {
            _ = passwordView.becomeFirstResponder()
        }
    }
}

//Cyclelife
extension PasswordViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    private func configureView() {
        setDoneButton()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColors.titlesColor]
        
        setTextsInLanguage()
        _ = passwordView.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(passwordViewPressed))
        passwordView.addGestureRecognizer(tap)
    }
    
    private func setDoneButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("general.doneButton", comment: ""), style: .done, target: self, action: #selector(passwordFinishedEnter))
    }
    
    private func setTextsInLanguage() {
        self.title = NSLocalizedString("settings.changePassword.title", comment: "")
        
        confirmPasswordButton.setTitle(NSLocalizedString("settings.changePassword.createNewPasswordButton", comment: ""), for: .normal)
    }
    
    @objc private func passwordViewPressed() {
        if !passwordView.isFirstResponder {
            _ = passwordView.becomeFirstResponder()
        }
    }
    
    func showErrorMessage(message: String) {
        let alertTitle = NSLocalizedString("register.registerErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
            self.passwordView.clearPassword()
        }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func passwordFinishedEnter() {
        showLoading(true)
        _ = passwordView.resignFirstResponder()
        presenter.createNewPasswordButtonPressed(passwordView.password)
    }
    
    func showLoading(_ show: Bool) {
        show ? showLoadingIndicator() : hideLoadingIndicator()
    }
}

extension PasswordViewController: SettingsPasswordViewProtocol {
    func confirmNewPassword() {
        confirmPasswordButton.setTitle(NSLocalizedString("settings.changePassword.confirmNewPasswordButton", comment: ""), for: .normal)
        passwordView.clearPassword()
        showLoading(false)
        _ = passwordView.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("general.doneButton", comment: ""), style: .done, target: self, action: #selector(passwordFinishedEnter))
    }
    
    func navigateBackToSettings() {
        self.navigationController?.popViewController(animated: true)
        showLoading(false)
    }
    
    func showError(_ error: String) {
        showLoading(false)
        
        let alertTitle = NSLocalizedString("register.registerErrorTitle", comment: "")
        let alertMessage = error
        let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
            self.confirmPasswordButton.setTitle(NSLocalizedString("settings.changePassword.createNewPasswordButton", comment: ""), for: .normal)
            self.passwordView.clearPassword()
        }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
}
