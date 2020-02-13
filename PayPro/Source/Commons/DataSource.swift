//
//  DataSource.swift
//  Infinit
//
//  Created by Infinit on 17/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

                    //  isSuccess Data  ErrorDescription
typealias ServiceHandler = (Bool, Data?, String?) -> Void
typealias LoginServiceHandler = (Bool, DataResponse<Data>?) -> Void

class DataSource {
    
    func makePetition(urlString: String, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding? = JSONEncoding.default, handle: @escaping ServiceHandler) {
        
        AlamofireManager.sessionManager
            .request(
                urlString,
                method: method,
                parameters: params,
                encoding: encoding!,
                headers: PayproRequest.headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    handle(true, data, nil)
                case .failure:
                    if response.response != nil {
                        if let data = response.data {
                            do {
                                let serverResponse = try JSONDecoder().decode(ServerError.self, from: data)
                                if let exception = serverResponse.exception, exception == SpecificErrors.expiredToken {
                                    let statusToken = KeychainWrapper.standard.delete(forKey: KeychainValues.KeychainToken)
                                    let statusPassword = KeychainWrapper.standard.delete(forKey: KeychainValues.KeychainPassKey)
                                
                                    print ("Deleted token status: \(statusToken)")
                                    print ("Deleted user status: \(statusPassword)")
                                    handle(false, nil, exception)
                                } else {
                                    handle(false, nil, serverResponse.desc ?? NSLocalizedString("general.error", comment: ""))
                                }
                            } catch {
                                handle(false, nil, NSLocalizedString("general.error", comment: ""))
                            }
                        } else {
                          handle(false, nil, NSLocalizedString("general.error", comment: ""))
                        }
                    } else {
                        handle(false, nil, NSLocalizedString("general.conectivityError", comment: ""))
                    }
                }
        }
    }
}
