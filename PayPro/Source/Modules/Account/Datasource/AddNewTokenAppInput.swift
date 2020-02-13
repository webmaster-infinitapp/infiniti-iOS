//
//  AddNewTokenAppInput.swift
//  Infinit
//
//  Created by Infinit on 12/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct AddNewTokenAppInput: Codable {
    
    var smartContratAddress: String?
    var tokenSymbol: String?
    var decimals: String?
    var tokenName: String?
    var password: String?
    
    init(smartContractAddress: String, tokenName: String, tokenSymbol: String, decimals: String?, password: String?) {
        self.smartContratAddress = smartContractAddress
        self.tokenName = tokenName
        self.tokenSymbol = tokenSymbol
        self.decimals = decimals
        self.password = password 
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
