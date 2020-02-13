//
//  SendStep5ViewController.swift
//  Infinit
//
//  Created by Infinit on 6/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class SendStep5ViewController: SendViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var readyTitleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var toTitleLabel: UILabel!
    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var gradientViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    
    var oldX: CGFloat?
    var startingX: CGFloat = 0
    
    var dragging: Bool = false
    
    init (presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep5ViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Cyclelife
extension SendStep5ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        addTabBarHeightIfIosLessThan11(bottomConstraint: bottomConstraint, inverse: false)
        configureView()
        if let presenter = self.presenter {
            quantityLabel.text = presenter.getAmount() + " " + getCurrency(currencyString: presenter.getCurrency())
            if presenter.getName().isEmpty {
                destinationNameLabel.text = NSLocalizedString("send.step5.emptyNameText", comment: "")
            } else {
                destinationNameLabel.text = presenter.getName()
            }
            keyLabel.text = presenter.getAddress()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = NSLocalizedString("send.step5.title", comment: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.setGradientBackground(colorOne: CustomColors.customRed, colorTwo: CustomColors.customBlue, cornerRadius: gradientView.frame.size.height/2)
        oldX = gradientView.frame.midX
        
        containerView.layer.cornerRadius = containerView.frame.size.height/2
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    private func configureView() {
        setTextsInLanguage()
        
        let screenSize: CGRect = UIScreen.main.bounds
        gradientViewWidthConstraint.constant += -screenSize.width
        containerViewTrailingConstraint.constant += screenSize.width * 0.2
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setTextsInLanguage() {
        readyTitleLabel.text = NSLocalizedString("send.step5.readyTitleLabel", comment: "").uppercased()
        toTitleLabel.text = NSLocalizedString("send.step5.toTitleLabel", comment: "").uppercased()
        infoLabel.text = NSLocalizedString("send.step5.infoLabel", comment: "")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let touchPoint: CGPoint? = touch?.location(in: self.view)

        if gradientView.frame.contains(touchPoint!) {
            dragging = true
            startingX = (touchPoint?.x)!
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let touchPoint = touch?.location(in: self.view)

        if dragging {
            let differenceX = (touchPoint?.x)! - startingX
            
            let screenSize: CGRect = view.bounds
            let finalPoint = screenSize.width * 0.8
            
            if differenceX > 0 {
                gradientView.center = CGPoint(x: oldX! + differenceX, y: (gradientView.frame.midY))

                if (gradientView.frame.origin.x + gradientView.frame.size.width) > finalPoint {
                    presenter?.goToSendStep6ViewController(from: self)
                    dragging = false
                    UIView.animate(withDuration: 0.3) {
                        self.gradientView.center = CGPoint(x: (self.oldX)!, y: (self.gradientView.frame.midY))
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragging = false
        UIView.animate(withDuration: 0.3) {
            self.gradientView.center = CGPoint(x: (self.oldX)!, y: (self.gradientView.frame.midY))
        }
    }
}

extension SendStep5ViewController: SendStep5ViewProtocol {
    func showTransactionError(_ message: String) {
        let alertTitle = NSLocalizedString("send.step5.transactionError", comment: "")
        let alertMessage = message
        let retryButtonText = NSLocalizedString("send.step5.retryTransactionButton", comment: "")
        let okButtonText = NSLocalizedString("send.step5.transactionErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: okButtonText, style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: retryButtonText, style: .default, handler: { (action) in
            self.presenter?.goToSendStep6ViewController(from: self)
        })
        
        alert.addAction(okButtonAction)
        alert.addAction(retryAction)
        alert.preferredAction = retryAction
        self.present(alert, animated: true, completion: nil)
    }
}
