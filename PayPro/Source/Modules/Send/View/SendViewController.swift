//
//  SendRouteViewController.swift
//  Infinit
//
//  Created by Infinit on 6/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SendViewController: ParentViewController {
    
    var presenter: SendPresenterProtocol?
    
//    init (presenter: SendPresenterProtocol) {
//        self.presenter = presenter
//        super.init(nibName: "SendViewController", bundle: nil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName: String, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
}

extension SendViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.title = "Back"
//    }
    
    private func configureView() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColors.titlesColor]
        
        let backButton = UIBarButtonItem(title: NSLocalizedString("general.backButton", comment: ""), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    func setNextButton() {
        let nextButton = UIBarButtonItem(title: NSLocalizedString("general.nextButton", comment: ""), style: .plain, target: self, action: #selector(nextButtonPressed))
        self.navigationItem.setRightBarButtonItems([nextButton], animated: true)
    }
    
    @objc func nextButtonPressed() {
    }
}

extension SendViewController: SendViewProtocol {
    
}
