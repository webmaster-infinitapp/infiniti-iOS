//
//  GasLimitViewController.swift
//  Infinit
//
//  Created by Infinit on 2/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class GasLimitViewController: ParentViewController {
    
    let presenter: SettingsGasLimitPresenterProtocol
    
    @IBOutlet weak var setGasLimitLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gasLimitTextField: UITextField!

    init (presenter: SettingsGasLimitPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "GasLimitViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Cyclelife
extension GasLimitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    private func configureView() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColors.titlesColor]
        
        setTextsInLanguage()
        
        gasLimitTextField.text = presenter.getGasLimit()
        
        let saveButton = UIBarButtonItem(title: NSLocalizedString("settings.gasPrice.saveButton.title", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(GasLimitViewController.save(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.5176470588, green: 0.5725490196, blue: 0.6509803922, alpha: 1)
    }
    
    @objc func save(sender: UIBarButtonItem) {
        if gasLimitTextField.text != presenter.getGasLimit() {
            showLoadingIndicator()
            presenter.setGasLimit(gasLimit: gasLimitTextField.text!)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setTextsInLanguage() {
        self.title = NSLocalizedString("settings.gasLimit.title", comment: "")
        infoLabel.text = NSLocalizedString("settings.gasLimit.infoLabel", comment: "")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
}

extension GasLimitViewController: SettingsGasLimitViewProtocol {
    func onUpdateGasLimitSuccess() {
        hideLoadingIndicator()
        self.navigationController?.popViewController(animated: true)
    }
    
    func onUpdateGasLimitError(error: String) {
        hideLoadingIndicator()
        showErrorMessage(message: error)
        
    }

    func showErrorMessage(message: String) {
        hideLoadingIndicator()
        
        let alertTitle = NSLocalizedString("settings.gasLimit.ErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("settings.gasLimit.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.gasLimitTextField.text = self.presenter.getGasLimit() }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }

}
