//
//  UIImageView+image64.swift
//  Infinit
//
//  Created by Infinit on 02/04/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
extension UIImageView {
    func base64ToImage(image64: String) {
        if let dataDecoded = NSData(base64Encoded: image64, options: NSData.Base64DecodingOptions(rawValue: 0)) {
            if let decodedimage = UIImage(data: dataDecoded as Data) {
                self.image = decodedimage
            }
        }
    }
}
