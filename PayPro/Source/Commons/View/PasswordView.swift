//
//  RoundTextField.swift
//  Infinit
//
//  Created by Infinit on 01/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

@IBDesignable
class PasswordView: UIView, UITextFieldDelegate {

    private var passwordStackView: PasswordStackView!
    private var passwordTextField: PasswordTextField!
    
    weak var delegate: PasswordViewDelegate?
    
    @IBInspectable var digits: Int = 4 {
        didSet {
            setUpView()
        }
    }
    
    @IBInspectable var spacing: CGFloat = 10 {
        didSet {
            setUpView()
        }
    }
    
    override func awakeFromNib() {
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    private func setUpView() {
        frame.size.height = 33
        frame.size.width = CGFloat(33 * digits) + (spacing * CGFloat(digits - 1))
        removeSubViews()
        passwordStackView = PasswordStackView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), digits: digits, spacing: spacing)
        passwordTextField = PasswordTextField()
        addSubview(passwordTextField)
        addSubview(passwordStackView)
        passwordTextField?.delegate = self
        widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
    }
    
    private func removeSubViews() {
        NSLayoutConstraint.deactivate(subviews.flatMap({ $0.constraints }))
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        let currentStringLength = currentString.length
        let newStringLength = newString.length
        if newStringLength > currentStringLength && currentStringLength < digits {
            password = String(newString)
            increment()
        } else if newStringLength < currentStringLength {
            password = String(newString)
            reduce()
        }
        
        if self.delegate != nil {
            self.delegate?.passwordView(self, hasNewAmountOfInputCharacters: newStringLength)
        }
        
        return newStringLength <= digits
    }
    
    private func reduce() {
        (passwordStackView.arrangedSubviews as? [PasswordStackView.RoundView])?.last(where: { $0.innerRoundView.backgroundColor == #colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1) })?.innerRoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func increment() {
        (passwordStackView.arrangedSubviews as? [PasswordStackView.RoundView])?.first(where: { $0.innerRoundView.backgroundColor != #colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1) })?.innerRoundView.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1)
    }
    
    private class PasswordStackView: UIStackView {
        
        private var digits: Int!
        
        convenience init(frame: CGRect, digits: Int, spacing: CGFloat) {
            self.init(frame: frame)
            self.digits = digits
            self.spacing = spacing
            setUpView()
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        private func setUpView() {
            removeAllArrangedSubviews()
            axis = .horizontal
            for _ in 0...digits - 1 {
                addArrangedSubview(RoundView(frame: CGRect(x: 0, y: 0, width: 33, height: 33)))
            }
        }
    
        private func removeAllArrangedSubviews() {
            
            let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
                removeArrangedSubview(subview)
                return allSubviews + [subview]
            }
            NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
            removedSubviews.forEach({ $0.removeFromSuperview() })
        }
    
        internal class RoundView: UIView {
            
            internal var innerRoundView: UIView!
            
            public override init(frame: CGRect) {
                super.init(frame: frame)
                setUpView(parentWidth: frame.size.width)
            }
            
            required public init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)!
            }
            
            private func setUpView(parentWidth: CGFloat) {
                heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
                widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
                layer.cornerRadius = parentWidth / 2
                clipsToBounds = true
                backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.5647058824, blue: 0.6470588235, alpha: 1)
                
                innerRoundView = UIView()
                addSubview(innerRoundView)
                innerRoundView.frame = CGRect(x: 1, y: 1, width: parentWidth - 2, height: parentWidth - 2)
                innerRoundView.heightAnchor.constraint(equalToConstant: innerRoundView.frame.size.height).isActive = true
                innerRoundView.widthAnchor.constraint(equalToConstant: innerRoundView.frame.size.width).isActive = true
                innerRoundView.layer.cornerRadius = (parentWidth / 2) - 1
                innerRoundView.clipsToBounds = true
                innerRoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                innerRoundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                innerRoundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            }
        }
    }
    
    private class PasswordTextField: UITextField {
        
        convenience init() {
            self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            keyboardType = UIKeyboardType.numberPad
            autocorrectionType = UITextAutocorrectionType.no
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
    }
    
    var password = ""
    
    override var isFirstResponder: Bool {
        return passwordTextField.isFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        return passwordTextField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return passwordTextField.resignFirstResponder()
    }
    
    func clearPassword() {
        password = ""
        passwordTextField.text = ""
        for _ in 0...digits {
            reduce()
        }
    }
}

protocol PasswordViewDelegate: class {
    func passwordView(_ passwordView: PasswordView, hasNewAmountOfInputCharacters charCount: Int)
}
