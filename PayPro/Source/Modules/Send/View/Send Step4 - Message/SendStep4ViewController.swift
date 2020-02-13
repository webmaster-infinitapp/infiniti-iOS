//
//  SendStep4ViewController.swift
//  Infinit
//
//  Created by Infinit on 6/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SendStep4ViewController: SendViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    init (presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep4ViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Cyclelife
extension SendStep4ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = NSLocalizedString("send.step4.title", comment: "")
    }
    
    private func configureView() {
        setTextsInLanguage()
        setNextButton()
        messageTextField.delegate = self
    }
    
    private func setTextsInLanguage() {
        infoLabel.text = NSLocalizedString("send.step4.infoLabel", comment: "")
        infoLabel.textColor = CustomColors.grayLabels
        messageTextField.placeholder = NSLocalizedString("send.step4.messageTextField.placeholder", comment: "")
        messageTextField.textColor = #colorLiteral(red: 0.2784313725, green: 0.3215686275, blue: 0.368627451, alpha: 1)
    }
    
    override func nextButtonPressed() {
        presenter?.goToSendStep5ViewController(from: self)
    }
}

extension SendStep4ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.setMessage(message: textField.text!)
    }
}
