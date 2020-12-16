//
//  KeychainManager.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private let service = "UnSplash"
    
    func set(_ value: String, key: String) {
        guard let data = value.data(using: .utf8) else { return }
        SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: data
        ] as CFDictionary, nil)
    }
    
    func get(_ key: String) -> String? {
        var result: AnyObject?
        SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: true,
        ] as NSDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func isEmpty(_ key: String) -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: false,
        ] as NSDictionary, nil)
        if status == errSecSuccess { return false }
        return true
    }
}
