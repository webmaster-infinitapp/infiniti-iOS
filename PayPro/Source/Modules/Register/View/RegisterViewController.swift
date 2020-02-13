//
//  RegisterViewController.swift
//  Infinit
//
//  Created by Infinit on 27/6/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

import UIKit

class RegisterViewController: ParentViewController {
    
    var presenter: RegisterPresenterProtocol?
    
    @IBOutlet weak var singUpLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var telephoneNumberTextField: UITextField!

    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var agreeTermsLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    init() {
        super.init(nibName: "RegisterViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onCreateAccountButtonClicked(_ sender: UIButton?) {
        showLoadingIndicator()
        presenter?.onCreateAccountButtonClicked(
            username: nameTextField.text!,
            countryCode: countryCodeTextField.text!,
            telephoneNumber: telephoneNumberTextField.text!)
    }
    
    @IBAction func onScreenTouched(_ sender: Any) {
        if nameTextField.isFirstResponder {
            _ = nameTextField.resignFirstResponder()
        } else if countryCodeTextField.isFirstResponder {
            _ = countryCodeTextField.resignFirstResponder()
        } else if telephoneNumberTextField.isFirstResponder {
            _ = telephoneNumberTextField.resignFirstResponder()
        }
    }
    
    @IBAction func onTermsAndConditionsButtonClicked(_ sender: UIButton) {
        presenter?.onTermsAndConditionsButtonClicked()
    }
    
    @IBAction func onSignInButtonClicked(_ sender: UIButton) {
        presenter?.onSignInButtonClicked()
    }
}

extension RegisterViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
        setTextsInLanguage()
        nameTextField.delegate = self
        countryCodeTextField.delegate = self
        telephoneNumberTextField.delegate = self
    }
    
    private func setTextsInLanguage() {
        
        title = NSLocalizedString("login.backButton", comment: "")
        signInLabel.text = NSLocalizedString("register.title", comment: "")
        
        nameTextField.placeholder = NSLocalizedString("register.nameLabel", comment: "")
        countryCodeTextField.placeholder = NSLocalizedString("register.countryCodeLabel", comment: "")
        telephoneNumberTextField.placeholder = NSLocalizedString("register.telephoneNumberLabel", comment: "")
        
        createAccountButton.setTitle(NSLocalizedString("register.createAccountButton", comment: ""), for: .normal)
        agreeTermsLabel.text = NSLocalizedString("register.agreeTermsLabel", comment: "")
        signInLabel.text = NSLocalizedString("register.haveAccountLabel", comment: "")
        
        let buttonsAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: CustomColors.grayLabels, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let termsAttributedButton = NSMutableAttributedString(string: NSLocalizedString("register.agreeTermsButton", comment: ""), attributes: buttonsAttributes)
        let signInAttributedButton = NSMutableAttributedString(string: NSLocalizedString("register.haveAccountButton", comment: ""), attributes: buttonsAttributes)
        termsButton.setAttributedTitle(termsAttributedButton, for: .normal)
        signInButton.setAttributedTitle(signInAttributedButton, for: .normal)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameTextField:
            countryCodeTextField.becomeFirstResponder()
        case countryCodeTextField:
            telephoneNumberTextField.becomeFirstResponder()
        default:
            telephoneNumberTextField.resignFirstResponder()
        }
        return true
    }
}

extension RegisterViewController: RegisterViewProtocol {
    
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
    
    func removeLoadingIndicator() {
        hideLoadingIndicator()
    }
}
