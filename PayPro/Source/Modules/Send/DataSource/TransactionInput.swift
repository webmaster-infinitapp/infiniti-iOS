//
//  TransactionInput.swift
//  Infinit
//
//  Created by Infinit on 04/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct TransactionInput: Codable {
    
    var descripcion: String
    var valor: Double
    var destino: String
    var password: String
    
    init(descripcion: String, valor: Double, destino: String, password: String) {
        
        self.descripcion = descripcion
        self.valor = valor
        self.destino = destino
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
