//
//  PrivateKeyInput.swift
//  Infinit
//
//  Created by Infinit on 30/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct PrivateKeyInput: Codable {
    
    var password: String?
    
    init() {
        let keychainWrapper = KeychainWrapper.standard
        guard let pin: String = keychainWrapper.read(forKey: KeychainValues.KeychainPassKey, reason: "Reason") as? String else {
            return
        }

        self.password = pin
    }
    
    func getAsParameters() -> Parameters? {
        var parameters: Parameters?
        if let data = try? JSONEncoder().encode(self) {
            let object = try? JSONSerialization.jsonObject(with: data, options: [])
            parameters = object as? Parameters
        }
        return parameters
    }
}
