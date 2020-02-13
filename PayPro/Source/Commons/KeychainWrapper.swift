//
//  KeychainWrapper.swift
//  VMKeychainWrapper
//

import Foundation
import Security
import LocalAuthentication

struct KeychainConstants {
    
    static var defaultServiceName: String {
        return Bundle.main.bundleIdentifier ?? "VMKeychainWrapper"
    }
    
    static let SecMatchLimit: String! = kSecMatchLimit as String
    static let SecReturnData: String! = kSecReturnData as String
    static let SecReturnPersistenRef: String! = kSecReturnPersistentRef as String
    static let SecValueData: String! = kSecValueData as String
    static let SecAttrAccessible: String! = kSecAttrAccessible as String
    static let SecClass: String! = kSecClass as String
    static let SecAttrService: String! = kSecAttrService as String
    static let SecAttrGeneric: String! = kSecAttrGeneric as String
    static let SecAttrAccount: String! = kSecAttrAccount as String
    static let SecAttrAccessGroup: String! = kSecAttrAccessGroup as String
    static let SecReturnAttributes: String! = kSecReturnAttributes as String
    static let SecUseOperationPrompt: String! = kSecUseOperationPrompt as String
    
    @available(iOS 9.0, *)
    static let SecUseAuthenticationUI: String! = kSecUseAuthenticationUI as String
    
    private init() {}
}

@objc
public protocol KeychainWrapperInterface {
    init(serviceName: String, accessGroup: String)
    func add(forKey key: String, value: Any, accessibility: CFTypeRef, authentication: Bool) -> OSStatus
    func update(forKey key: String, value: Any, reason: String) -> OSStatus
    func delete(forKey key: String) -> OSStatus
    func restoreKeychain() -> OSStatus
    func rawValue(forKey key: String, reason: String) -> Data?
    func read(forKey key: String, reason: String) -> Any?
}

@objc
public class KeychainWrapper: NSObject {
    
    public static let defaultKeychainWrapper = KeychainWrapper.standard
    public static let standard = KeychainWrapper()
    
    var serviceName: String
    var accessGroup: String?
    
    public required override init() {
        self.serviceName = KeychainConstants.defaultServiceName
        self.accessGroup = nil
        super.init()
    }
    
    public required init(serviceName: String, accessGroup: String) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
        super.init()
    }
}

extension KeychainWrapper: KeychainWrapperInterface {
    public func add(forKey key: String, value: Any, accessibility: CFTypeRef, authentication: Bool) -> OSStatus {
        let valueData = encode(value: value)
        var queryDictionary: [String: Any] = setupQueryDictionary(forService: serviceName, key: key)
        queryDictionary[KeychainConstants.SecReturnData] = kCFBooleanTrue
        
        if #available(iOS 9.0, *) {
            queryDictionary[KeychainConstants.SecUseAuthenticationUI] = authentication
        }
        
        queryDictionary[KeychainConstants.SecValueData] = valueData
        queryDictionary[KeychainConstants.SecAttrAccessible] = accessibility
        
        let status = SecItemAdd(queryDictionary as CFDictionary, nil)
        return status
    }
    
    public func update(forKey key: String, value: Any, reason: String) -> OSStatus {
        let valueData = encode(value: value)
        var queryDictionary: [String: Any] = setupQueryDictionary(forService: serviceName, key: key)
        
        if reason.count > 0 {
            queryDictionary[KeychainConstants.SecUseOperationPrompt] = reason
        }
        
        let updatesDictionary: [String: Any] = [KeychainConstants.SecValueData: valueData]
        let status = SecItemUpdate(queryDictionary as CFDictionary, updatesDictionary as CFDictionary)
        return status
    }
    
    public func delete(forKey key: String) -> OSStatus {
        let queryDictionary: [String: Any] = setupQueryDictionary(forService: serviceName, key: key)
        let status = SecItemDelete(queryDictionary as CFDictionary)
        return status
    }
    
    public func restoreKeychain() -> OSStatus {
        let queryDictionary = setupQueryDictionary(forService: nil, key: nil)
        let status = SecItemDelete(queryDictionary as CFDictionary)
        return status
    }
    
    public func rawValue(forKey key: String, reason: String) -> Data? {
        var result: Data? = nil
        var queryDictionary: [String: Any] = setupQueryDictionary(forService: serviceName, key: key)
        queryDictionary[KeychainConstants.SecReturnData] = kCFBooleanTrue
        
        if reason.count > 0 {
            queryDictionary[KeychainConstants.SecUseOperationPrompt] = reason
        }
        
        var dataTypeRef: CFTypeRef? = nil
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let dataTypeRef = dataTypeRef as? Data {
            result = dataTypeRef
        }
        
        return result
    }
    
    public func read(forKey key: String, reason: String) -> Any? {
        guard let valueData = rawValue(forKey: key, reason: reason) else {
            return nil
        }
        
        let value = decode(data: valueData)
        return value
    }
}

private extension KeychainWrapper {
    func encode(value: Any) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        return data
    }
    
    func decode(data: Data) -> Any? {
        guard let value = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            return nil
        }
        
        return value
    }
    
    func setupQueryDictionary(forService serviceName: String?, key: String?) -> [String: Any] {
        var dictionary: [String: Any] = [KeychainConstants.SecClass: kSecClassGenericPassword]
        if let accessGroup = self.accessGroup, accessGroup.count > 0 {
            dictionary[KeychainConstants.SecAttrAccessGroup] = accessGroup
        }
        
        if let serviceName = serviceName, serviceName.count > 0 {
            dictionary[KeychainConstants.SecAttrService] = serviceName
        }
        
        if let key = key, key.count > 0 {
            dictionary[KeychainConstants.SecAttrAccount] = key
        }
        
        return dictionary
    }
}

extension KeychainWrapper {
    public func addPasswordKeychainWrapper(password: String?) {
        let addStatus = KeychainWrapper.standard.add(forKey: KeychainValues.KeychainPassKey, value: password as AnyObject, accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly, authentication: true)
        print("Added password status: \(addStatus)")
    }
    
    public func addUserKeyKeychainWrapper(user: String?) {
        let addStatus = KeychainWrapper.standard.add(forKey: KeychainValues.KeychainUserKey, value: user as AnyObject, accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly, authentication: true)
        print("Added user status: \(addStatus)")
    }
    
    public func addTokenKeychainWrapper(token: String?) {
        let addStatus = KeychainWrapper.standard.add(forKey: KeychainValues.KeychainToken, value: token as AnyObject, accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly, authentication: true)
        print("Added token status: \(addStatus)")
    }
}
