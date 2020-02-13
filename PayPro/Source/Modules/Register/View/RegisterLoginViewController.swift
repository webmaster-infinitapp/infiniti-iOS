//
//  LoginUsernameViewController.swift
//  Infinit
//
//  Created by Infinit on 06/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

class RegisterLoginViewController: ParentViewController {
    
    var presenter: RegisterLoginPresenterProtocol?
    
    @IBOutlet weak var agreeTermsLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    init() {
        super.init(nibName: "RegisterLoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onNextButtonClicked(_ sender: UIBarButtonItem) {
        showLoadingIndicator()
        nextButtonClicked()
    }
    
    @IBAction func onTermsAndConditionsButtonClicked(_ sender: UIButton) {
        presenter?.onTermsAndConditionsButtonClicked()
    }
    
    @IBAction func onScreenTouched(_ sender: Any) {
        if username.isFirstResponder {
            _ = username.resignFirstResponder()
        }
    }
}

extension RegisterLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        setNextButton()
        setTextsInLanguage()
        setNavBarColors()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        username.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
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
        
        title = NSLocalizedString("login.loginButton", comment: "")
        username.placeholder = NSLocalizedString("login.username.tip", comment: "")
        agreeTermsLabel.text = NSLocalizedString("login.agreeTermsLabel", comment: "") 
        
        let buttonsAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: CustomColors.grayLabels, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let termsAttributedButton = NSMutableAttributedString(string: NSLocalizedString("register.agreeTermsButton", comment: ""), attributes: buttonsAttributes)
        termsButton.setAttributedTitle(termsAttributedButton, for: .normal)
    }
    
    @objc private func nextButtonClicked() {
        presenter?.onLoginNextButtonClicked(username: username.text!)
    }
}

extension RegisterLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        username.resignFirstResponder()
        nextButtonClicked()
        return true
    }
}

extension RegisterLoginViewController: RegisterLoginViewProtocol {
    
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
