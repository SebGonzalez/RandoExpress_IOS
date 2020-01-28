//
//  Rando.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation

struct Rando {
    var id :UInt
    var name :String
    var description :String
    var ville :String
    var dateDepart :String
    var latitude :String
    var longitude :String
    var owner :Personne
    var persons = [Personne]()
}
