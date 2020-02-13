//
//  UIImageView+Circled.swift
//  Infinit
//
//  Created by Infinit on 06/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
