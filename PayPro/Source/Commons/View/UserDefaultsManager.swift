//
//  UserDefaultsManager.swift
//  PayPro
//
//  Created by Victor Alvarez Pazos on 31/10/2018.
//  Copyright © 2018 VectorMobile. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var name: String? {
        get { return UserDefaults.standard.string(forKey: "name") }
        set { UserDefaults.standard.set(newValue, forKey: "name") }
    }
    
    static var telephone: String? {
        get { return UserDefaults.standard.string(forKey: "telephone") }
        set { UserDefaults.standard.set(newValue, forKey: "telephone") }
    }
    
    static var pin: String? {
        get { return UserDefaults.standard.string(forKey: "pin") }
        set { UserDefaults.standard.set(newValue, forKey: "pin") }
    }
    
    static var token: String? {
        get { return UserDefaults.standard.string(forKey: "token") }
        set { UserDefaults.standard.set(newValue, forKey: "token") }
    }
}
