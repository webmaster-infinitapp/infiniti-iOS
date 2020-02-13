//
//  UIImageView+image64.swift
//  Infinit
//
//  Created by Infinit on 02/04/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
extension UIImage {
    func imageToBase64() -> String {
        let imageData = self.jpegData(compressionQuality: 1)
        if imageData != nil {
            let base64String = imageData!.base64EncodedString()
            return base64String
        } else {
            return ""
        }
    }

    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
