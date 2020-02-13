//
//  SendStep3ViewController.swift
//  Infinit
//
//  Created by Infinit on 5/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SendStep3ViewController: SendViewController {
    
    @IBOutlet weak var chooseAssetLabel: UILabel!
    @IBOutlet weak var chooseAssetButton: UIButton!
    @IBOutlet weak var assetAmountTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var availableBalanceNumberLabel: UILabel!
    @IBOutlet weak var availableBalanceSymbolLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var availableTokens: [RetrieveTokenListOutputData] = []
    var currencyPickerData: [String] = [String]()
    var chooseAssetLabelTextDependingOnLanguage = NSLocalizedString("send.step3.chooseAssetLabel", comment: "")
    
    init (presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep3ViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didScanChooseAssetButtonTouchUpInside(_ sender: Any) {
        pickerView.isHidden = false
        configureTapGesture()
    }
}

//Cyclelife
extension SendStep3ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = NSLocalizedString("send.step3.title", comment: "")
        showLoadingIndicator()
        presenter?.getTokensList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.assetAmountTextField?.resignFirstResponder()
    }
    
    private func configureView() {
        setTextsInLanguage()
        setNextButton()
        assetAmountTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        availableBalanceNumberLabel.text = "..."
        availableBalanceSymbolLabel.text = ""
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(AddTokenViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
        pickerView.isHidden = true
        let str = chooseAssetLabel.text
        let defaultCharacter = ""
        let result = String(str?.prefix(6) ?? defaultCharacter.prefix(6))
        if pickerView.tag == 0 && (availableBalanceSymbolLabel.text == availableTokens[0].symbol! || result == chooseAssetLabelTextDependingOnLanguage.prefix(6)) {
            
            chooseAssetLabel.attributedText = addArrowToString(currencyPickerData: currencyPickerData[0])
            availableBalanceNumberLabel.text = availableTokens[0].balance!
            presenter?.setAvailableAmount(availableAmount: availableTokens[0].balance!)
            availableBalanceSymbolLabel.text = availableTokens[0].symbol!
            presenter?.setCurrency(currency: currencyPickerData[0])
        
            pickerView.tag = 1
        }
    }
    
    private func addArrowToString(currencyPickerData: String) -> NSAttributedString {
        let chooseAsset = currencyPickerData
        let text = NSMutableAttributedString(string: chooseAsset + "   ")
        let attachmentString = createArrowString()
        text.append(attachmentString)
        
        return text
    }
    
    private func createArrowString() -> NSAttributedString {
        let copyIconAttachement = NSTextAttachment()
        copyIconAttachement.image = UIImage(named: "arrowIcon")
        copyIconAttachement.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        let attachementString = NSAttributedString(attachment: copyIconAttachement)
        
        return attachementString
    }
    
    private func setTextsInLanguage() {
        let chooseAsset = NSLocalizedString("send.step3.chooseAssetLabel", comment: "")
        let text = NSMutableAttributedString(string: chooseAsset + "   ")
        let attachmentString = createArrowString()
        text.append(attachmentString)
        
        chooseAssetLabel.attributedText = text
        
        infoLabel.text = NSLocalizedString("send.step3.infoLabel", comment: "")
        infoLabel.textColor = CustomColors.grayLabels
        availableBalanceLabel.text = NSLocalizedString("send.step3.availableBalanceLabel", comment: "")
    }
    
    override func nextButtonPressed() {
        let convertedAssetAmountTextField = (assetAmountTextField.text!.replacingOccurrences(of: ",", with: ".") as NSString).floatValue
        let convertedAvailableAmountTextField = (availableBalanceNumberLabel.text! as NSString).floatValue
        
        if chooseAssetLabel.text != "Choose Asset" && convertedAssetAmountTextField > 0.00 && convertedAssetAmountTextField <= convertedAvailableAmountTextField && hasValidFormatting(string: availableBalanceNumberLabel.text!) {
            presenter?.goToSendStep4ViewController(from: self)
        } else if hasValidFormatting(string: assetAmountTextField.text!) == false {
            showErrorMessage(message: NSLocalizedString("send.step3.errorDescription.amountFormatError", comment: ""))
        } else if chooseAssetLabel.text == "Choose Asset" && convertedAssetAmountTextField == 0.00 {
            showErrorMessage(message: NSLocalizedString("send.step3.errorDescription.asset&AmountError", comment: ""))
        } else if chooseAssetLabel.text == "Choose Asset" {
            showErrorMessage(message: NSLocalizedString("send.step3.errorDescription.assetError", comment: ""))
        } else if convertedAssetAmountTextField == 0 {
            showErrorMessage(message: NSLocalizedString("send.step3.errorDescription.amountError", comment: ""))
        } else if convertedAssetAmountTextField > convertedAvailableAmountTextField {
            showErrorMessage(message: NSLocalizedString("send.step3.errorDescription.notEnoughAvailableAmount", comment: ""))
        }
    }
    
    private func hasValidFormatting(string: String) -> Bool {
        let stringWithPoints = string.replacingOccurrences(of: ",", with: ".")
        
        let pointsOccurences = stringWithPoints.components(separatedBy: ".").count - 1
        
        if pointsOccurences <= 1 && string.count == string.onlyDigits().count + pointsOccurences {
            return true
        } else {
            return false
        }
    }
    
    private func getCurrency(currencyString: String) -> String {
        let colonIndex = (currencyString.range(of: "(", options: .backwards)?.lowerBound)!
        let indexAfterColon = currencyString.index(after: colonIndex)
        var currency = currencyString.suffix(from: indexAfterColon)
        currency = currency.prefix(currencyString.count - 2)
        currency = currency.dropLast()
        return String(currency)
    }
    
    private func navigateBack() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}

extension SendStep3ViewController: SendStep3ViewProtocol {
    
    func onGetTokensListSuccess(tokensList: [RetrieveTokenListOutputData]) {
        availableTokens = tokensList
        currencyPickerData = []
        for token in tokensList {
            currencyPickerData.append("\(token.descripcion!) (\(token.symbol!))")
        }
        pickerView.reloadAllComponents()
        hideLoadingIndicator()
    }
    
    func showTokensError() {
        hideLoadingIndicator()
        
        let alertTitle = NSLocalizedString("send.step3.errorDescription.title", comment: "")
        let alertMessage = NSLocalizedString("send.step3.showTokensErrorMessage", comment: "")
        let retryButtonText = NSLocalizedString("send.step3.retryShowTokensButton", comment: "")
        let goBackButtonText = NSLocalizedString("send.step3.showTokensErrorGoBackButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let goBackAction = UIAlertAction(title: goBackButtonText, style: .cancel, handler: { (action) in
            self.navigateBack()
        })
        let retryAction = UIAlertAction(title: retryButtonText, style: .default, handler: { (action) in
            self.showLoadingIndicator()
            self.presenter?.getTokensList()
        })
        
        alert.addAction(goBackAction)
        alert.addAction(retryAction)
        alert.preferredAction = retryAction
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(message: String) {
        let alertTitle = NSLocalizedString("send.step3.errorDescription.title", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("send.step3.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.printStep3ViewControllerError(message: message)}))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printStep3ViewControllerError(message: String) {
        print("error: \(message)")
    }
}

extension SendStep3ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter?.setCurrency(currency: currencyPickerData[row])
        presenter?.setOriginAddress(originAddress: availableTokens[row].cuenta!)
        chooseAssetLabel.attributedText = addArrowToString(currencyPickerData: currencyPickerData[row])
        availableBalanceNumberLabel.text = availableTokens[row].balance!
        presenter?.setAvailableAmount(availableAmount: availableTokens[row].balance!)
        availableBalanceSymbolLabel.text = availableTokens[row].symbol!
        assetAmountTextField.text! = "0.00"
        pickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = currencyPickerData[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: CustomColors.titlesColor])
    }
}

extension SendStep3ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if assetAmountTextField.text! == "0.00" {
            assetAmountTextField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! == "" {
            textField.text = "0.00"
        }
        presenter?.setAmount(amount: textField.text!.replacingOccurrences(of: ",", with: "."))
    }
}
