//
//  AuthGestionnaire.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 12/02/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation

extension String: Error {}

class AuthGestionnaire {
    
    var jwt :String?
    
    private static var sharedAuthGestionnaire: AuthGestionnaire = {
        let authGestionnaire = AuthGestionnaire()
        
        return authGestionnaire
    }()
    
    // Initialization
    
    private init() {
        let tag = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        //guard status == errSecSuccess else { }
        if(status == errSecSuccess) {
            var data = item as! Data
            jwt = String(decoding: data, as: UTF8.self)
        }
        else {
            jwt = nil
        }
        
        print("Le token save : ")
        print(jwt)
    }
    
    
    
    func saveJWT(jwtSave : String) throws {
        let value: Data = jwtSave.data(using: .utf8)!
        let tag: Data = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        addToKeychain(value, tag: tag)
    }
    
    func deleteJWT(jwtSave : String) throws {
        let value: Data = jwtSave.data(using: .utf8)!
        let tag: Data = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        removeFromKeychain(value, tag: tag)
    }
    
    @discardableResult
    func addToKeychain(_ value: Data, tag: Data) -> Bool {
        let attributes: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecValueData): value
        ]
        
        var result: CFTypeRef? = nil
        let status = SecItemAdd(attributes as CFDictionary, &result)
        if status == errSecSuccess {
            print("Successfully added to keychain.")
        } else {
            if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                print(error)
            }
            
            return false
        }
        
        return true
    }
    
    @discardableResult
    func removeFromKeychain(_ value: Data, tag: Data) -> Bool {
        let attributes: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecValueData): value
        ]
        
        let status = SecItemDelete(attributes as CFDictionary)
        if status == errSecSuccess {
            print("Successfully removed from keychain.")
        } else {
            if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                print(error)
            }
            
            return false
        }
        
        return true
    }
    
    class func shared() -> AuthGestionnaire {
        return sharedAuthGestionnaire
    }
    
}

