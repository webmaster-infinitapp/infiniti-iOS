//
//  ServerError.swift
//  Infinit
//
//  Created by Infinit on 27/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

struct ServerError: Codable {
    
    var num: Int?
    var desc: String?
    
    var status: Int?
    var exception: String?
    var message: String?
}
