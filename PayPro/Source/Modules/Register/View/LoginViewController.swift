//
//  LoginViewController.swift
//  Infinit
//
//  Created by Infinit on 14/12/2017.
//  Copyright © 2017 Infinit. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController {
    
    var presenter: LoginPresenterProtocol?
    var params: Codable?
    var uncheckedPassword: String?
    
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var passwordView: PasswordView!
    @IBOutlet weak var switchAccountButton: UIButton!
    
    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
        uncheckedPassword = params as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onScreenTouched(_ sender: UIButton) {
        if passwordView.isFirstResponder {
            _ = passwordView.resignFirstResponder()
        } else {
            _ = passwordView.becomeFirstResponder()
        }
    }
    
    @objc func doneButtonClicked() {
        showLoadingIndicator()
        presenter?.onLoginDoneButtonClicked(password: passwordView.password)
    }
    
    @IBAction func switchAccountClicked(_ sender: UIButton) {
        presenter?.onSwitchAccountClicked()
    }
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureView() {
        setTextsInLanguage()
        passwordView.delegate = self
        _ = passwordView.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(passwordViewPressed))
        passwordView.addGestureRecognizer(tap)
    }
    
    private func setTextsInLanguage() {
        signInLabel.text = NSLocalizedString("login.signInTitle", comment: "")

        let buttonsAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: CustomColors.grayLabels, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let switchAccountAttributedButton = NSMutableAttributedString(string: NSLocalizedString("login.switchAccount", comment: ""), attributes: buttonsAttributes)
        switchAccountButton.setAttributedTitle(switchAccountAttributedButton, for: .normal)
    }
    
    @objc private func passwordViewPressed() {
        if !passwordView.isFirstResponder {
            _ = passwordView.becomeFirstResponder()
        }
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func showErrorMessage(message: String) {
        let alertTitle = NSLocalizedString("register.registerErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
            self.printLoginError(message: message)
            self.clearPassword()
        }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printLoginError(message: String) {
        print("error: \(message)")
    }
    
    func clearPassword() {
        passwordView.clearPassword()
    }
    
    func removeLoadingIndicator() {
        hideLoadingIndicator()
    }
}

extension LoginViewController: PasswordViewDelegate {
    func passwordView(_ passwordView: PasswordView, hasNewAmountOfInputCharacters charCount: Int) {
        if charCount >= 6 {
            showLoadingIndicator()
            presenter?.onLoginDoneButtonClicked(password: passwordView.password)
        }
    }
}
