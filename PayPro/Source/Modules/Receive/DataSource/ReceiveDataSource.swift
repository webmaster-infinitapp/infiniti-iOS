//
//  ReceiveDataSource.swift
//  Infinit
//
//  Created by Infinit on 27/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

class ReceiveDataSource: DataSource, ReceiveDataSourceProtocol {
    
    func retrievePublicKey(handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.publicKey)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }
}
