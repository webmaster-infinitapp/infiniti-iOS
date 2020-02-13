//
//  AccountDataSource.swift
//  Infinit
//
//  Created by Infinit on 06/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

class AccountDataSource: DataSource, AccountDataSourceProtocol {
    
    func retrieveTokenList(handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.balance)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }
    
    func requestAddToken(with parameters: Parameters, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.addNewToken)"
        makePetition(urlString: url, method: .post, params: parameters, handle: handle)
    }
    
    func retrieveTransactionHistory(handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.transactionHistory)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }

    func retrieveTransactionDetail(transactionItem: String, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.transactionDetail)\(transactionItem)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }
}
