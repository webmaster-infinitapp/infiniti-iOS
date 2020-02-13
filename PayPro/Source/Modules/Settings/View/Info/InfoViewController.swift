//
//  InfoViewController.swift
//  Infinit
//
//  Created by Infinit on 12/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: ParentViewController {
    
    var presenter: SettingsInfoPresenterProtocol
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    init (presenter: SettingsInfoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "InfoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Buttons actions
    
    @IBAction func didTermsOfServiceTouchUpInside(_ sender: Any) {
        presenter.termsOfServiceButtonPressed()
    }
    
    @IBAction func didPrivacyPolicyTouchUpInside(_ sender: Any) {
        presenter.privacyPolicyButtonPressed()
    }
    
    @IBAction func didWebsiteButtonTouchUpInside(_ sender: Any) {
        presenter.websiteButtonPressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabBarHeightIfIosLessThan11(bottomConstraint: topConstraint, inverse: false)
        configureView()
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
    }
    
    private func setTextsInLanguage() {
        self.title = NSLocalizedString("settings.info.title", comment: "")
        termsOfServiceLabel.text = NSLocalizedString("settings.info.termsOfServiceLabel", comment: "")
        privacyPolicyLabel.text = NSLocalizedString("settings.info.privacyPolicyLabel", comment: "")
        websiteLabel.text = NSLocalizedString("settings.info.websiteLabel", comment: "")
    }
}

//Cyclelife
extension InfoViewController: SettingsInfoViewProtocol {
    func showURL (_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.openURL(url)
        }
    }
}
