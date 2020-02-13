//
//  PrivateKeyViewController.swift
//  Infinit
//
//  Created by Infinit on 3/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class PrivateKeyViewController: ParentViewController {
    
    let presenter: SettingsPrivateKeyPresenterProtocol
    
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var passwordView: PasswordView!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var privateKeyCodeLabel: UILabel!
    @IBOutlet weak var cautionLabel: UILabel!
    
    var privateKey = ""
    
    init (presenter: SettingsPrivateKeyPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "PrivateKeyViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Buttons Actions
    @IBAction func didConfirmButtonTouchUpInside(_ sender: Any) {
        passwordFinishedEnter()
    }
    
    @IBAction func onScreenPassword(_ sender: Any) {
        if passwordView.isFirstResponder {
            _ = passwordView.resignFirstResponder()
        } else {
            _ = passwordView.becomeFirstResponder()
        }
    }
}

//Cyclelife
extension PrivateKeyViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.delegate = self
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColors.titlesColor]
        
        setTextsInLanguage()
        _ = passwordView.becomeFirstResponder()
        confirmPasswordView.isHidden = false
        
        privateKeyCodeLabel.isUserInteractionEnabled = true
        privateKeyCodeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PrivateKeyViewController.privateKeyLabelDidTap)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(passwordViewPressed))
        passwordView.addGestureRecognizer(tap)
    }

    private func setTextsInLanguage() {
        self.title = NSLocalizedString("settings.privateKey.title", comment: "")
   
        confirmPasswordButton.setTitle(NSLocalizedString("settings.privateKey.confirmPaswwordButton", comment: ""), for: .normal)
        privateKeyLabel.text = NSLocalizedString("settings.privateKey.yourPrivateKeyLabel", comment: "")
        cautionLabel.text = NSLocalizedString("settings.privateKey.cautionLabel", comment: "")
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
        showLoadingIndicator()
        presenter.confirmPasswordButtonPressed(password: passwordView.password)
    }
    
    private func createAttachmenString() -> NSAttributedString {
        let copyIconAttachement = NSTextAttachment()
        copyIconAttachement.image = UIImage(named: "copyIcon")
        copyIconAttachement.bounds = CGRect(x: 0, y: -5.0, width: 25, height: 25)
        
        let attachementString = NSAttributedString(attachment: copyIconAttachement)
        
        return attachementString
    }
    
    @objc func privateKeyLabelDidTap(sender: UITapGestureRecognizer) {
        presenter.copyPrivateKeyToClipboardButtonPressed()
    }
}

extension PrivateKeyViewController: SettingsPrivateKeyViewProtocol {
    
    func passwordConfirmed() {
        _ = passwordView.resignFirstResponder()
        presenter.retrievePrivateKey()
    }
    
    func setPrivateKey(_ privateKey: String) {
        self.privateKey = privateKey
        let key = NSMutableAttributedString(string: privateKey + "  ")
        key.append(createAttachmenString())
        privateKeyCodeLabel.attributedText = key
        hideLoadingIndicator()
        confirmPasswordView.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
    }
    
    func copyPrivateKeyToClipboard() {
        UIPasteboard.general.string = privateKey
        self.view.showToast(toastMessage: NSLocalizedString("general.copyToClipboard", comment: ""))
    }
    
    func showError(_ error: String) {
        hideLoadingIndicator()
        passwordView.clearPassword()
        showErrorMessage(message: error)
    }
}

extension PrivateKeyViewController: PasswordViewDelegate {
    func passwordView(_ passwordView: PasswordView, hasNewAmountOfInputCharacters charCount: Int) {
        if charCount >= 6 {
            passwordFinishedEnter()
        }
    }
}
