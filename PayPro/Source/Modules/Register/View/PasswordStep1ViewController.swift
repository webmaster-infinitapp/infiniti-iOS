//
//  PasswordStep1ViewController.swift
//  Infinit
//
//  Created by Infinit on 30/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

class PasswordStep1ViewController: ParentViewController, RegisterStep1ViewProtocol {
    
    var presenter: RegisterStep1PresenterProtocol?
    
    @IBOutlet weak var createNewPasswordButton: UIButton!
    @IBOutlet weak var passwordView: PasswordView!
    
    init() {
        super.init(nibName: "PasswordStep1ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onCreateNewPasswordButton(_ sender: Any) {
        nextButtonClicked()
    }
    
    @IBAction func onScreenTouched(_ sender: UIButton) {
        if passwordView.isFirstResponder {
            _ = passwordView.resignFirstResponder()
        } else {
            _ = passwordView.becomeFirstResponder()
        }
    }
    
    @objc func nextButtonClicked() {
        presenter?.onPasswordStep1DoneButtonClicked(password: passwordView.password)
    }
}

extension PasswordStep1ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordView.clearPassword()
    }
    
    private func configureView() {
        setTextsInLanguage()
        setNextButton()
        setNavBarColors()
        _ = passwordView.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(passwordViewPressed))
        passwordView.addGestureRecognizer(tap)
    }
    
    private func setNextButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("general.nextButton", comment: ""), style: .done, target: self, action: #selector(nextButtonClicked))
    }
    
    private func setNavBarColors() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3481967449, green: 0.3963935375, blue: 0.4443202019, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1)
    }
    
    private func setTextsInLanguage() {
        createNewPasswordButton.setTitle(NSLocalizedString("passwordStep1.createNewPasswordButton.text", comment: ""), for: .normal)
        createNewPasswordButton.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1), for: .normal)
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
    
    func removeLoadingIndicator() {
        hideLoadingIndicator()
    }
}
