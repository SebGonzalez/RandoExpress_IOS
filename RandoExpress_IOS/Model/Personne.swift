//
//  Personne.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 27/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation

struct Personne {
    
    var id :UInt
    var lastName :String
    var firstName :String
    var mail :String
    var password :String
}

extension Personne {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let firstName = json["firstName"] as? String,
            let mail = json["mail"] as? String,
            let password = json["password"] as? String
        else {
            return nil
        }
        self.id = UInt(id)
        self.lastName = name
        self.firstName = firstName
        self.mail = mail
        self.password = password
    }
}
