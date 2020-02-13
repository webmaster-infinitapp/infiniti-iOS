//
//  UIView+Gradient.swift
//  Infinit
//
//  Created by Infinit 6/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, cornerRadius: CGFloat) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
