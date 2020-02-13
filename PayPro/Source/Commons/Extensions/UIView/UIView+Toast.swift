//
//  UIView+Toast.swift
//  Infinit
//
//  Created by Infinit on 31/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UIView {
    func showToast (toastMessage: String) {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = .clear
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = UIColor.black
        lblMessage.backgroundColor = UIColor(red: CGFloat(200/255.0), green: CGFloat(200/255.0), blue: CGFloat(200/255.0), alpha: CGFloat(1))
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont(name: "System", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle: CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle: CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width: maxSizeTitle.width.getminimum(value2: expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2: expectedSizeTitle.height))
        lblMessage.frame = CGRect(x: ((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2), y: (self.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration: TimeInterval(0.5), delay: 0, options: [], animations: {
            lblMessage.alpha = 1
        }, completion: { _ in
            UIView.animateKeyframes(withDuration: TimeInterval(0.5), delay: 1, options: [], animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            }, completion: { _ in
                bgView.removeFromSuperview()
            })
            
            //            UIView.animate(withDuration: TimeInterval(duration*2), delay: 20, options: [], animations: {
            //                lblMessage.alpha = 0
            //                bgView.alpha = 0
            //            })
            //            bgView.removeFromSuperview()
        })
    }
}

extension CGFloat {
    func getminimum (value2: CGFloat) -> CGFloat {
        if self < value2 {
            return self
        } else {
            return value2
        }
    }
}

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
   /* override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }*/
}
