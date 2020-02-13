//
//  SessionManager.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

final class AlamofireManager {
    
    static let sessionManager: SessionManager = {
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "putYourAddressHere": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
}

final class PayproRequest: Encodable {

    static var headers: HTTPHeaders {
        var httpHeaders: HTTPHeaders = [:]
        if let token: String = KeychainWrapper.standard.read(forKey: KeychainValues.KeychainToken, reason: "Reason") as? String {
            httpHeaders["Authorization"] = token
        }
        httpHeaders["Content-Type"] = "application/json"
        return httpHeaders
    }

    static func setToken(from response: HTTPURLResponse?) {
        if let headers = response?.allHeaderFields as? [String: String] {
            if let token = headers["Authorization"] {
                let prefix = "Paypro "
                if token.hasPrefix(prefix) {
                    if let _ = KeychainWrapper.standard.read(forKey: KeychainValues.KeychainToken, reason: "Reason") {
                        let status = KeychainWrapper.standard.update(forKey: KeychainValues.KeychainToken, value: String(token.dropFirst(prefix.count)), reason: "Reason")
                        print ("Updated token status: \(status)")
                    } else {
                        KeychainWrapper.standard.addTokenKeychainWrapper(token: String(token.dropFirst(prefix.count)))
                    }
                    
                    
                }
            }
        }
    }

//    static var token: String?
//
//    static var headers: HTTPHeaders {
//        var httpHeaders: HTTPHeaders = [:]
//        if let token = self.token {
//            httpHeaders["Authorization"] = token
//        }
//        httpHeaders["Content-Type"] = "application/json"
//        return httpHeaders
//    }
//
//    static func setToken(from response: HTTPURLResponse?) {
//        if let headers = response?.allHeaderFields as? [String: String] {
//            if let token = headers["Authorization"] {
//                let prefix = "Paypro "
//                if token.hasPrefix(prefix) {
//                    self.token = String(token.dropFirst(prefix.count))
//                }
//            }
//        }
//    }
//
    static func setCookie(response: DataResponse<Data>) {
        let url = URL(string: "putYourAddressHere")!
        if let headers = response.response?.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
            AlamofireManager.sessionManager.session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
        }
    }
}
