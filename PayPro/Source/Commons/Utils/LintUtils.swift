//
//  LintUtils.swift
//  Infinit
//
//  Created by Infinit on 07/03/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation

class LintUtils {

    static public func castSafely<T>(_ object: Any, expectedType: T.Type) -> T {
        guard let typedObject = object as? T else {
            fatalError("ERROR IN castSafely Expected object: \(object) to be of type: \(expectedType)")
        }
        return typedObject
    }
}
