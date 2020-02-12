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
    
    var jwt :SecKey?
    
    private static var sharedAuthGestionnaire: AuthGestionnaire = {
        let authGestionnaire = AuthGestionnaire()
        
        return authGestionnaire
    }()
    
    // Initialization
    
    private init() {
        let tag = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                       kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        //guard status == errSecSuccess else { }
        if(status == errSecSuccess) {
            jwt = item as! SecKey
        }
        else {
            jwt = nil
        }
        
        print("Le token save : ")
        print(jwt)
    }
    
    func saveJWT(jwtSave : String) throws {
        let tag = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueRef as String: jwtSave.data(using: String.Encoding.utf8)]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        print("status : ")
        print(status)
        guard status == errSecSuccess else { throw  "erreur"  }
    }
    
    class func shared() -> AuthGestionnaire {
        return sharedAuthGestionnaire
    }
    
}

