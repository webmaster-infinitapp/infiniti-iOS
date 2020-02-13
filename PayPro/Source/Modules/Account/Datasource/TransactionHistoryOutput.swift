//
//  TransactionHistoryOutput.swift
//  Infinit
//
//  Created by Infinit on 15/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

struct TransactionHistoryOutput: Codable {
    
    var decimal: Int?
    var token: String?
    var destino: String?
    var mensaje: String?
    var numBloque: Int?
    var fecha: String?
    var hasTransaccion: String?
    var origen: String?
    var tipo: String?
    var ether: String?
    var txFee: String?
    var status: String?
    var mensajeError: String?
}
