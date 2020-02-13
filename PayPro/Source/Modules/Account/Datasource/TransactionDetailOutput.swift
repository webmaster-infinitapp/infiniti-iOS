//
//  TransactionDetailOutput.swift
//  Infinit
//
//  Created by Infinit on 21/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

struct TransactionDetailOutput: Codable {
    
    var transaccion: String?
    var bloque: String?
    var fecha: Int?
    var mensaje: String?
    var estado: String?
    var confirmaciones: Int?
    var destino: String?
    var cantidad: String?
    var moneda: String?
    var txFee: String?
}
