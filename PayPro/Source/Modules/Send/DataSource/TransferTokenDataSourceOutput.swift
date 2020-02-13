//
//  TransferTokenDataSourceOutput.swift
//  Infinit
//
//  Created by Infinit on 03/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

struct TransferTokenOutputData: Codable {
    var hasTransaccion: String
    var numBloque: Int
    var fecha: String
    var origen: String
    var tipo: String
    var destino: String
    var ether: String
    var txFee: String
    var token: String
    var status: String
    var mensaje: String
    var decimal: Int
    var mensajeError: String?
}
