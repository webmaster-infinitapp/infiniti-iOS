//
//  LoginId.swift
//  PayPro
//
//  Created by Sergio Yague Carpio on 15/11/2018.
//  Copyright © 2018 VectorMobile. All rights reserved.
//

import Foundation
import Alamofire

struct LoginId: Codable {
    
    var loginId: String?
    
    init(loginId: String) {
        self.loginId = loginId
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
