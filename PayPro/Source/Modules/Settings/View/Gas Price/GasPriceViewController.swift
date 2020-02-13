//
//  GasPriceViewController.swift
//  Infinit
//
//  Created by Infinit on 2/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class GasPriceViewController: ParentViewController {
    
    let presenter: SettingsGasPricePresenterProtocol
    
    @IBOutlet weak var gasPricePickerView: UIPickerView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var gasPriceInGweis: String
    
    var gasPricePickerData: [String] = [String]()

    init (presenter: SettingsGasPricePresenterProtocol) {
        self.presenter = presenter
        self.gasPriceInGweis = presenter.getGasPrice()
        super.init(nibName: "GasPriceViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Cyclelife
extension GasPriceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColors.titlesColor]
        
        setTextsInLanguage()
        
        gasPricePickerView.delegate = self
        gasPricePickerView.dataSource = self
        
        setGasPricePickerView()
        
        let saveButton = UIBarButtonItem(title: NSLocalizedString("settings.gasPrice.saveButton.title", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(GasPriceViewController.save(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.5176470588, green: 0.5725490196, blue: 0.6509803922, alpha: 1)
        
    }
    
    @objc func save(sender: UIBarButtonItem) {
        if gasPriceInGweis != presenter.getGasPrice() {
            showLoadingIndicator()
            presenter.setGasPrice(gasPrice: gasPriceInGweis)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setTextsInLanguage() {
        self.title = NSLocalizedString("settings.gasPrice.title", comment: "")
        infoLabel.text = NSLocalizedString("settings.gasPrice.infoLabel", comment: "")
    }
    
    private func setGasPricePickerView() {
        if gasPricePickerData.count == 0 {
            for count in 1...100 {
                gasPricePickerData.append("\(count) Gwei")
            }
        }
        let currentGasPrice = gasPriceInGweis
    
        if let indexOfA = gasPricePickerData.index(of: "\(currentGasPrice) Gwei") {
            preselectedComboOptions(selectedRow: indexOfA)
        }
    }
    
    private func preselectedComboOptions(selectedRow: Int) {
        gasPricePickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    }
    
    private func getGasPriceStringNumber(gasPriceString: String) -> String {
        let gasPriceExtension = " Gwei"
        let number = gasPriceString.prefix(gasPriceString.count - gasPriceExtension.count)
        return String(number)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
}

extension GasPriceViewController: SettingsGasPriceViewProtocol {
    func onUpdateGasPriceSuccess() {
        hideLoadingIndicator()
        self.navigationController?.popViewController(animated: true)
    }
    
    func onUpdateGasPriceError(error: String) {
        hideLoadingIndicator()
        
        let alertTitle = NSLocalizedString("register.registerErrorTitle", comment: "")
        let alertMessage = error
        let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
            self.gasPriceInGweis = self.presenter.getGasPrice()
            self.setGasPricePickerView()
        }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
}

extension GasPriceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gasPricePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gasPricePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gasPriceInGweis = getGasPriceStringNumber(gasPriceString: gasPricePickerData[row])
    }
}
