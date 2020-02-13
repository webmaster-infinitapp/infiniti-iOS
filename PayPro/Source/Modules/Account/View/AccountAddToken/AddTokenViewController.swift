//
//  AddTokenViewController.swift
//  Infinit
//
//  Created by Infinit on 25/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

class AddTokenViewController: ParentViewController {
    
    var presenter: AccountAddTokenPresenterProtocol?
    
    @IBOutlet weak var addTokenButton: UIButton!
    @IBOutlet weak var tokenDetailsLabel: UILabel!
    @IBOutlet weak var tokenSymbolTextField: UITextField!
    @IBOutlet weak var tokenNameTextField: UITextField!
    @IBOutlet weak var smartContactAddressTextField: UITextField!
    @IBOutlet weak var decimalsTextField: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    init () {
        super.init(nibName: "AddTokenViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onAddTokenButtonDetailPressed(_ sender: Any) {
        let keychainWrapper = KeychainWrapper.standard
        guard let userId: String = keychainWrapper.read(forKey: KeychainValues.KeychainUserKey, reason: "Reason") as? String else {
            return
        }
        
        presenter?.newTokenAddTokenButtonPressed(smartContractAddress: smartContactAddressTextField.text!, tokenName: tokenNameTextField.text!, tokenSymbol: tokenSymbolTextField.text!, decimals: decimalsTextField.text!, password: userId)
    }
}

extension AddTokenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        configureView()
        configureTextFields()
        configureTapGesture()
        self.title = NSLocalizedString("account.addToken.title", comment: "")
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        addTokenButton.layer.cornerRadius = 10
    }

    private func configureView() {
        tokenDetailsLabel.text = NSLocalizedString("account.addToken.tokenDetailsLabel", comment: "")
        
        tokenSymbolTextField.placeholder = NSLocalizedString("account.addToken.tokenSymbolTextField.placeholder", comment: "")
        
        tokenNameTextField.placeholder = NSLocalizedString("account.addToken.tokenNameTextField.placeholder", comment: "")
        
        smartContactAddressTextField.placeholder = NSLocalizedString("account.addToken.smartContactAddressTextField.placeholder", comment: "")
        
        decimalsTextField.placeholder = NSLocalizedString("account.addToken.decimalsTextField", comment: "")
    
        addTokenButton.setTitle(NSLocalizedString("account.addToken.addTokenButton", comment: ""), for: .normal)
    }
    
    private func configureTextFields() {
        tokenSymbolTextField.delegate = self
        tokenNameTextField.delegate = self
        smartContactAddressTextField.delegate = self
        decimalsTextField.delegate = self
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(AddTokenViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

extension AddTokenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case smartContactAddressTextField:
            tokenNameTextField.becomeFirstResponder()
        case tokenNameTextField:
            tokenSymbolTextField.becomeFirstResponder()
        case tokenSymbolTextField:
            decimalsTextField.becomeFirstResponder()
        default:
            decimalsTextField.resignFirstResponder()
        }
        return true
    }
}

extension AddTokenViewController: AccountAddTokenViewProtocol {
    
    func showErrorMessage(message: String) {
        let alertTitle = NSLocalizedString("account.addToken.ErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("account.addToken.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.printAddTokenError(message: message) }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printAddTokenError(message: String) {
        print("error: \(message)")
    }
}
