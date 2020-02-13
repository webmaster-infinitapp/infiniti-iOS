//
//  String+image64.swift
//  Infinit
//
//  Created by Infinit on 17/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

extension String {
    func base64ToString() -> String {
        if let decodedData = Data(base64Encoded: self) {
            if let decodedString = String(data: decodedData, encoding: .utf8) {
                return decodedString
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func stringToBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
