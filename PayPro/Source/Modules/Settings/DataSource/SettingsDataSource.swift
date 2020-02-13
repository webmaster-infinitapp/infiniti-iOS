//
//  UpdateGasPriceInput.swift
//  Infinit
//
//  Created by Infinit on 22/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

class SettingsDataSource: DataSource, SettingsDataSourceProtocol {
        
    func retrieveUserProfile(handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.profile)"
        makePetition(urlString: url, method: .get, params: nil, handle: handle)
    }
    
    func retrievePrivateKey(handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.privateKey)"
        makePetition(urlString: url, method: .post, params: PrivateKeyInput().getAsParameters()!, handle: handle)
    }
    
    func retrieveChangePassword(_ newPassword: String, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.changePassword)"
        makePetition(urlString: url, method: .post, params: ChangePasswordInput(newPassword).getAsParameters()!, handle: handle)
    }
    
    func updateGasPrice(gasPrice: String, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.updateGasPrice)\(gasPrice)"
        makePetition(urlString: url, method: .post, params: nil, handle: handle)
    }
    
    func updateGasLimit(gasLimit: String, handle: @escaping ServiceHandler) {
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.updateGasLimit)\(gasLimit)"
        makePetition(urlString: url, method: .post, params: nil, handle: handle)
    }
    
    func updatePhoto(image: String, handle: @escaping ServiceHandler) {
        
        let url = "\(EnvironmentConstants.hostUrl)\(PayproEndpoints.updatePhoto)"
        makePetition(urlString: url, method: .post, params: [:], encoding: image, handle: handle)
    }
}
