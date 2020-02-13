//
//  RetreiveTokenListDataSourceOutput.swift
//  Infinit
//
//  Created by Infinit on 15/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct RetrieveTokenListOutputData: Codable {
    
    var cuenta: String?
    var descripcion: String?
    var symbol: String?
    var balance: String?
}
