//
//  PasswordStep2DataSourceInput.swift
//  Infinit
//
//  Created by Infinit on 30/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct PasswordStep2InputData: Codable {
    
    var idUsuario: String?
    var codPais: String?
    var telefono: String?
    var nombre: String?
    var password: String?
    var alias: String?
    
    init(codPais: String, telefono: String, idUsuario: String, nombre: String, password: String) {
        self.idUsuario = idUsuario
        self.codPais = codPais
        self.telefono = telefono
        self.nombre = nombre
        self.password = password
        alias = idUsuario
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
