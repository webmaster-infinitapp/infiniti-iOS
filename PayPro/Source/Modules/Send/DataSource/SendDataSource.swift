//
//  SendDataSource.swift
//  Infinit
//
//  Created by Infinit on 05/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

class SendDataSource: DataSource, SendDataSourceProtocol {
       
    func checkContacts(with parameters: Parameters, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.checkContacts)"
        makePetition(urlString: url, method: .post, params: parameters, encoding: ArrayEncoding(), handle: handle)
    }
    
    func getTokensList(handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.balance)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }
    
    func transferToken(with parameters: Parameters, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.transferToken)"
        makePetition(urlString: url, method: .post, params: parameters, handle: handle)
    }
    
    func transaction(with parameters: Parameters, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.transaction)"
        makePetition(urlString: url, method: .post, params: parameters, handle: handle)
    }
}
