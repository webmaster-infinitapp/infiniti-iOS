//
//  CustomMultipleTextField.swift
//  PayPro
//
//  Created by dcarenas on 29/6/18.
//  Copyright © 2018 VectorMobile. All rights reserved.
//

import UIKit

protocol CustomMultipleTextFieldDelegate: class {
    func onTextFieldCompleted(text: String)
    func onTextFieldDelete()
}

class CustomMultipleTextField: UIView {
    var numberOfFields: Int = 0
    var arrayTextFields: [UITextField] = []
    var arrayCircles: [UIView] = []
    var returnTextValue = ""
    var previousCharacter: String?
    var isNumbersOnly: Bool = false
    var position = 0
    
    weak var delegate: CustomMultipleTextFieldDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public func set(numberOfFields: Int, isNumbersOnly: Bool) {
        
        self.numberOfFields = numberOfFields
        self.isNumbersOnly = isNumbersOnly
        
        if arrayTextFields.count == numberOfFields {
            for textField in arrayTextFields {
                textField.text = ""
            }
            resetOriginalState()
        } else {
            self.configureTextFields()
        }
    }
    
    public func resetOriginalState() {
        for circleView in arrayCircles {
            circleView.backgroundColor = CustomColors.lightGray
        }
        for singleTextField in arrayTextFields {
            singleTextField.textColor = CustomColors.darkGray
        }
    }
    
    private func configureTextFields() {
        let fieldWidth: CGFloat = 33
        let screenWidth = UIScreen.main.bounds.size.width
        let marginsSpace = screenWidth - fieldWidth * CGFloat(numberOfFields)
        let margins = marginsSpace / CGFloat(6 + (numberOfFields - 1))
        var frameX: CGFloat
        for index in 0 ..< self.numberOfFields {
            frameX = 3 * margins + (margins + fieldWidth)*CGFloat(index)
            let field = UITextField(frame: CGRect(x: frameX, y: self.frame.height/2, width: fieldWidth, height: fieldWidth))
            field.font = UIFont(name: "Lato-Bold", size: 16)
            //field.isHidden = true
            field.textColor = CustomColors.bordersColor
            field.keyboardType = isNumbersOnly ? UIKeyboardType.numberPad : UIKeyboardType.default
            field.textAlignment = .center
            field.tag = index + 1
            field.delegate = self
            arrayTextFields.append(field)
            self.addSubview(field)
            
            let circleView = UIView(frame: CGRect(x: frameX, y: self.frame.height/2, width: fieldWidth, height: fieldWidth))
            circleView.addAllBordersWithColor(color: CustomColors.bordersColor, width: 0.33, radius: fieldWidth/2)
            circleView.backgroundColor = CustomColors.Background.white
            arrayCircles.append(circleView)
            self.addSubview(circleView)
        }
        
        let coverButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        coverButton.addTarget(self, action: #selector(viewClicked(_:)), for: .touchUpInside)
        
        self.addSubview(coverButton)
    }
    
    private func fieldsToText() -> String {
        var returnText = ""
        for singleTextField in arrayTextFields {
            returnText = "\(returnText)\(singleTextField.text ?? "")"
        }
        return returnText
    }
    
    public func setViewColors(color: UIColor) {
        for circleView in arrayCircles {
            circleView.backgroundColor = color
        }
        for singleTextField in arrayTextFields {
            singleTextField.textColor = color
        }
    }
    
    @objc private func viewClicked(_ sender: UIButton) {
        arrayTextFields[position].becomeFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        arrayTextFields[position].becomeFirstResponder()
        return true
    }
}

extension CustomMultipleTextField: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == numberOfFields {
            arrayTextFields.last?.isSecureTextEntry = true
            if position == numberOfFields - 1 {
                returnTextValue = fieldsToText()
                delegate?.onTextFieldCompleted(text: returnTextValue)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            let prevTag: Int = textField.tag - 1
            if let previousResponder: UIResponder? = self.viewWithTag(prevTag) {
                delegate?.onTextFieldDelete()
                
                if let previousResponderTextField = previousResponder as? UITextField {
                    position -= 1
                    previousResponderTextField.becomeFirstResponder()
                }
                textField.isSecureTextEntry = false
                textField.text = ""
                arrayCircles[textField.tag - 1].backgroundColor = CustomColors.Background.white
                
                return false
            }
        }
        let nextTag: Int = textField.tag + 1
        arrayCircles[textField.tag - 1].backgroundColor = CustomColors.grayLabels
        if string.count == 1 {
            if let nextResponder: UIResponder? = self.viewWithTag(nextTag) {
                textField.isSecureTextEntry = true
                nextResponder?.becomeFirstResponder()
                if let _ = nextResponder as? UITextField {
                    position += 1
                    textField.text = string
                }
            } else {
                textField.isSecureTextEntry = true
                textField.text = string
            }
            return false
        }
        return true
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }
    
    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}
