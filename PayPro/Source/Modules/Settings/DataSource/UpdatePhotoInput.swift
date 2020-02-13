//
//  UpdatePhotoInput.swift
//  Infinit
//
//  Created by Infinit on 17/12/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire

struct UpdatePhotoInput: Codable {
    
    var photo: String?
    
    init(_ photo: String) {
        self.photo = photo
    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
