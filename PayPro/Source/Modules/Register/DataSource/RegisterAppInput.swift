//
//  RegisterDataSourceInput.swift
//  Infinit
//
//  Created by Infinit on 30/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct RegisterAppInput: Codable {
    
    var username = EnvironmentConstants.otpUsername
    var password = ""
    
    func getAsParameters() -> Parameters? {
        var parameters: Parameters?
        if let data = try? JSONEncoder().encode(self) {
            let object = try? JSONSerialization.jsonObject(with: data, options: [])
            parameters = object as? Parameters
        }
        return parameters
    }
}
