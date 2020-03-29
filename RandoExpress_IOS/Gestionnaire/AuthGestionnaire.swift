//
//  AuthGestionnaire.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 12/02/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation

extension String: Error {}

/// Classe nous permettant de gérer et d'interragire avec l'utilisateur connecté.
class AuthGestionnaire {

    var jwt :String?
    var firstName :String?
    var lastName :String?
    var email :String
    var id :String
    
    private static var sharedAuthGestionnaire: AuthGestionnaire = {
        let authGestionnaire = AuthGestionnaire()
        
        return authGestionnaire
    }()

    /// Méthode d'initialisation.
    private init() {
        let tag = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        //guard status == errSecSuccess else { }
        if(status == errSecSuccess) {
            let data = item as! Data
            jwt = String(decoding: data, as: UTF8.self)
        }
        else {
            jwt = nil
        }
        
        id = ""
        email = ""
        ///////////
        print("Le token save : ")
        print(jwt ?? "")
        
        print("Le prénom save : ")
        print(getConnectedFirstName())
        
        print("Le nom save : ")
        print(getConnectedLastName())
        
        print("Le mail save : ")
        print(getConnectedEmail())
        
        print("Le id save : ")
        print(getConnectedId())
    }

    /// Retourne le prénom de l'utilisateur.
    func getConnectedFirstName() -> String
    {
        let tag2 = "fr.luminy.RandoExpress-IOS.keys.firstName".data(using: .utf8)!
        
        let getquery2: [String: Any] = [kSecClass as String: kSecClassKey,
                                        kSecAttrApplicationTag as String: tag2,
                                        kSecReturnData as String: true]
        
        var item2: CFTypeRef?
        let status2 = SecItemCopyMatching(getquery2 as CFDictionary, &item2)
        //guard status == errSecSuccess else { }
        if(status2 == errSecSuccess) {
            let data2 = item2 as! Data
            firstName = String(decoding: data2, as: UTF8.self)
            return firstName!
        }
        else {
            firstName = nil
        }
        
        return "error"
    }

    /// Retourne le nom de l'utilisateur.
    func getConnectedLastName() -> String {
        let tag3 = "fr.luminy.RandoExpress-IOS.keys.name".data(using: .utf8)!
        
        let getquery3: [String: Any] = [kSecClass as String: kSecClassKey,
                                        kSecAttrApplicationTag as String: tag3,
                                        kSecReturnData as String: true]
        
        var item3: CFTypeRef?
        let status3 = SecItemCopyMatching(getquery3 as CFDictionary, &item3)
        //guard status == errSecSuccess else { }
        if(status3 == errSecSuccess) {
            let data3 = item3 as! Data
            lastName = String(decoding: data3, as: UTF8.self)
            return lastName!
        }
        else {
            lastName = nil
        }
        
        return "error"
    }

    /// Retourne l'email de l'utilisateur.
    func getConnectedEmail() -> String{
        let tag4 = "fr.luminy.RandoExpress-IOS.keys.mail".data(using: .utf8)!
        
        let getquery4: [String: Any] = [kSecClass as String: kSecClassKey,
                                        kSecAttrApplicationTag as String: tag4,
                                        kSecReturnData as String: true]
        
        var item4: CFTypeRef?
        let status4 = SecItemCopyMatching(getquery4 as CFDictionary, &item4)
        //guard status == errSecSuccess else { }
        if(status4 == errSecSuccess) {
            let data4 = item4 as! Data
            email = String(decoding: data4, as: UTF8.self)
            return email
        }
        else {
            email = "error"
        }
        
        return "error"
    }

    /// Retourne l'id de l'utilisateur.
    func getConnectedId() -> String{
        let tag = "fr.luminy.RandoExpress-IOS.keys.id".data(using: .utf8)!
        
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                        kSecAttrApplicationTag as String: tag,
                                        kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        //guard status == errSecSuccess else { }
        if(status == errSecSuccess) {
            let data = item as! Data
            id = String(decoding: data, as: UTF8.self)
            return id
        }
        else {
            id = "error"
        }
        
        return "error"
    }

    /**
     Méthode nous permettant de sauvegarder les caractéristique de la personne connecter
     dans la KeyChain. permettant de

     - Parameters:
        - firstName: Le prénom de la personne
        - lastName: Le nom de la personne
        - email: L'email de la personne
        - id: L'id de la personne
     */
    func savePerson(firstName :String, lastName :String, email :String, id :String) throws {
        
        print("before add Le prénom save : ")
        print(firstName)
        
        print("before add Le nom save : ")
        print(lastName)
        
        print("before add Le mail save : ")
        print(email)
        
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.email = email
        addToKeychain(firstName.data(using: .utf8)!, tag :"fr.luminy.RandoExpress-IOS.keys.firstName".data(using: .utf8)!)
        addToKeychain(lastName.data(using: .utf8)!, tag :"fr.luminy.RandoExpress-IOS.keys.name".data(using: .utf8)!)
        addToKeychain(email.data(using: .utf8)!, tag :"fr.luminy.RandoExpress-IOS.keys.mail".data(using: .utf8)!)
        addToKeychain(id.data(using: .utf8)!, tag :"fr.luminy.RandoExpress-IOS.keys.id".data(using: .utf8)!)
    }
    
    /// Sauvegarde le jwt dans la KeyChain.
    func saveJWT(jwtSave : String) throws {
        self.jwt = jwtSave
        let value: Data = jwtSave.data(using: .utf8)!
        let tag: Data = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        addToKeychain(value, tag: tag)
    }

    /// Supprime le jwt de la KeyChain.
    func deleteJWT() throws {
        let value: Data = (jwt ?? "").data(using: .utf8)!
        let tag: Data = "fr.luminy.RandoExpress-IOS.keys.jwt".data(using: .utf8)!
        
        removeFromKeychain(value, tag: tag)
    }

    /// Méthode permettant de retirer l'utilisateur de la KeyChain.
    func decoFromKeyChain() throws {
        try deleteJWT()
        
        let value1: Data = (firstName ?? "").data(using: .utf8)!
        let tag1: Data = "fr.luminy.RandoExpress-IOS.keys.firstName".data(using: .utf8)!
        
        removeFromKeychain(value1, tag: tag1)
        
        let value2: Data = (lastName ?? "").data(using: .utf8)!
        let tag2: Data = "fr.luminy.RandoExpress-IOS.keys.name".data(using: .utf8)!
        
        removeFromKeychain(value2, tag: tag2)
        
        let value3: Data = (email ?? "").data(using: .utf8)!
        let tag3: Data = "fr.luminy.RandoExpress-IOS.keys.mail".data(using: .utf8)!
        
        removeFromKeychain(value3, tag: tag3)
        
        let value4: Data = (id ?? "").data(using: .utf8)!
        let tag4: Data = "fr.luminy.RandoExpress-IOS.keys.id".data(using: .utf8)!
        
        removeFromKeychain(value4, tag: tag4)
    }

    /// Méthode d'ajout dans la KeyChain.
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

    /// Méthode de suppression dans la KeyChain.
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

