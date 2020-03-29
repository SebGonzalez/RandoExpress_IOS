//
//  Rando.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation
/// Modèle d'une randonnée.
struct Rando {
    var id :UInt
    var name :String
    var description :String
    var ville :String
    var dateDepart :String
    var heureDepart :String
    var latitude :String
    var longitude :String
    var owner :Personne
    var persons = [Personne]()
    
    func containsPerson(id: UInt) -> Bool{
        print("Id personne : \(id)")
        for person in persons {
            print("Id test : \(person.id)")
            if(person.id == id) {
                print("id trouvé : \(person.id)")
                return true;
            }
        }
        return false;
    }
}

extension Rando {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? UInt,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let ville = json["ville"] as? String,
            let dateDepart = json["dateDepart"] as? String,
            let heureDepart = json["heureDepart"] as? String,
            let latitude = json["latitude"] as? String,
            let longitude = json["longitude"] as? String,
            let ownerJSON = json["owner"] as? [String: Any],
        
            let owner = Personne(json: ownerJSON),
            let personsJSON = json["persons"] as? [[String: Any]]
            else {
                return nil
        }
        
        self.id = UInt(id)
        self.name = name
        self.description = description
        self.ville = ville
        self.dateDepart = dateDepart
        self.heureDepart = heureDepart
        self.latitude = latitude
        self.longitude = longitude
        self.owner = owner
        
        for personJSON in personsJSON {
            self.persons.append(Personne(json: personJSON)!)
        }
        
    }
}
