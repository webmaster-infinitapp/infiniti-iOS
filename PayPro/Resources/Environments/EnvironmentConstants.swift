//
//  EnvironmentConstants.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

struct EnvironmentConstants {
    
    static var hostUrl: String {
        guard let host = Bundle.main.infoDictionary!["HOST_URL"] as? String else {
            return "no hostUrl data"
        }
        return host.replacingOccurrences(of: "\\", with: "")
    }
    
    static var termsAndConditionsURL: String {
        guard let result = Bundle.main.infoDictionary!["TERMS_CONDITIONS_URL"] as? String else {
            return "no terms and conditions data"
        }
        return result.replacingOccurrences(of: "\\", with: "")
    }
    
    static var otpUsername: String {
        guard let result = Bundle.main.infoDictionary!["OTP_USERNAME"] as? String else {
            return "no otp username found"
        }
        return result
    }
}
