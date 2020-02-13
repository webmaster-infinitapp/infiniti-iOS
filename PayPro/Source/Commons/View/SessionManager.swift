//
//  SessionManager.swift
//  PayPro
//
//  Created by Victor Alvarez Pazos on 29/10/2018.
//  Copyright © 2018 VectorMobile. All rights reserved.
//

import Foundation
import Alamofire

final class AlamofireManager {
    
    static let sessionManager: SessionManager = {
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "api.paypro.com": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
}

final class PayproRequest: Encodable {
    
    static let headers: HTTPHeaders? = {
        
        if let token = UserDefaults.token {
            return [ "Authorization": token, "Content-Type": "application/json" ]
        } else {
            return nil
        }
    }()
}
