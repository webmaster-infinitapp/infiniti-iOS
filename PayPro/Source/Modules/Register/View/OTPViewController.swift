//
//  OTPViewController.swift
//  Infinit
//
//  Created by Infinit on 30/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

class OTPViewController: ParentViewController {
    
    var presenter: RegisterOTPPresenterProtocol?
    
    @IBOutlet weak var otpHint: UILabel!
    @IBOutlet weak var passwordView: PasswordView!
    
    init() {
        super.init(nibName: "OTPViewController", bundle: nil)
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
    
    @objc func nextButtonClicked() {
        showLoadingIndicator()
        presenter?.onOTPDoneButtonClicked(otp: passwordView.password)
    }
}

extension OTPViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordView.clearPassword()
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureView() {
        setNextButton()
        setNavBarColors()
        setTextsInLanguage()
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
        otpHint.text =  NSLocalizedString("otp.hint", comment: "")
    }
    
    @objc private func passwordViewPressed() {
        if !passwordView.isFirstResponder {
            _ = passwordView.becomeFirstResponder()
        }
    }
}

extension OTPViewController: RegisterOTPViewProtocol {
    
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
