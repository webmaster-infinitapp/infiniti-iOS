//
//  TransferTokenInput.swift
//  Infinit
//
//  Created by Infinit on 03/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct TransferTokenInput: Codable {
    
    var descripcion: String?
    var valor: Double?
    var destino: String?
    var password: String?
    var origen: String?
    
    init(descripcion: String, valor: Double, destino: String, origen: String) {
        let keychainWrapper = KeychainWrapper.standard
        guard let pin: String = keychainWrapper.read(forKey: KeychainValues.KeychainPassKey, reason: "Reason") as? String else {
            return
        }
        
        self.descripcion = descripcion
        self.valor = valor
        self.destino = destino
        self.password = pin
        self.origen = origen
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
