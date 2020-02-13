//
//  RegisterDataSource.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

class RegisterDataSource: DataSource, RegisterDataSourceProtocol {
    
    var output: RegisterDataSourceOutputProtocol?
    
    func registerApp(with parameters: Parameters, handle: @escaping LoginServiceHandler) {
        AlamofireManager.sessionManager
            .request(
                "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.login)",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: nil)
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    handle(true, response)
                case .failure:
                    handle(false, response)
                }
        }
    }
    
    func requestOTP(with parameters: Parameters, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.otp)"
        makePetition(urlString: url, method: .post, params: parameters, handle: handle)
    }
    
    func checkUserId(userId: String, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.checkUserId)\(userId)"
        makePetition(urlString: url, method: .post, params: nil, handle: handle)
    }
    
    func signInWithOTP(otp: String, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.verifyOtp)\(otp)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }
    
    func registerWithPassword(with parameters: Parameters, handle: @escaping ServiceHandler) {
        let url =  "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.register)"
        makePetition(urlString: url, method: .post, params: parameters, handle: handle)
    }
    
    func login(with parameters: Parameters, handle: @escaping LoginServiceHandler) {
        AlamofireManager.sessionManager
            .request(
                "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.login)",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: PayproRequest.headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    handle(true, response)
                case .failure:
                    handle(false, response)
                }
        }
    }
}
