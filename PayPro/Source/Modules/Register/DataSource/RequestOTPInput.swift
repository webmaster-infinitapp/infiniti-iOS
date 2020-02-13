//
//  RequestOTPInput.swift
//  Infinit
//
//  Created by Infinit on 01/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct RequestOTPInput: Codable {
    
    var telefono: String?
    var codPais: String?
    
    init(telephone: String, countryCode: String) {
        telefono = telephone
        codPais = countryCode
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
