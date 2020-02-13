//
//  SendStep6ViewController.swift
//  Infinit
//
//  Created by Infinit on 6/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SendStep6ViewController: SendViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var transactionSubmitedView: UIView!
    @IBOutlet weak var transactionSubmitedViewYouRockLabel: UILabel!
    @IBOutlet weak var transactionSubmitedViewCuantityLabel: UILabel!
    @IBOutlet weak var transactionSubmitedViewInfoLabel: UILabel!
    
    init (presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep6ViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Cyclelife
extension SendStep6ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.tabBarController?.tabBar.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SendStep6ViewController.transactionSubmitedViewTapped))
        transactionSubmitedView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = NSLocalizedString("send.step6.title", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.makeTransactionOrTransferToken()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func transactionSubmitedViewTapped(sender: UITapGestureRecognizer) {
        presenter?.onTransactionSubmittedViewPressed()
    }
    
    private func configureView() {
        navigationItem.hidesBackButton = true

//        let transform: CGAffineTransform = CGAffineTransform(scaleX: 3, y: 3)
//        activityIndicator.transform = transform
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        
        setTextsInLanguage()
        
        transactionSubmitedView.isHidden = true
        transactionSubmitedView.alpha = 0
        
        if let presenter = self.presenter {
            transactionSubmitedViewCuantityLabel.text = presenter.getAmount() + " " + presenter.getCurrency()
        }
    }
    
    private func setTextsInLanguage() {
        infoLabel.text = NSLocalizedString("send.step6.infoLabel", comment: "")
        transactionSubmitedViewYouRockLabel.text = NSLocalizedString("send.step6.transactionSubmitedViewYouRockLabel", comment: "")
        transactionSubmitedViewInfoLabel.text = NSLocalizedString("send.step6.transactionSubmitedViewInfoLabel", comment: "")
    }
}

extension SendStep6ViewController: SendStep6ViewProtocol {
    
    func onTransactionSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3, animations: {
                self.transactionSubmitedView.isHidden = false
                self.transactionSubmitedView.alpha = 1
                self.navigationController?.isNavigationBarHidden = true
            })
        }
    }
    
    func navigateBack() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}
