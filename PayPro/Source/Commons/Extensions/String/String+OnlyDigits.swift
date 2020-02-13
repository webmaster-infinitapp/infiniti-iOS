//
//  String+OnlyDigits.swift
//  Infinit
//
//  Created by Infinit on 28/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

extension String {
    func onlyDigits() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
