//
//  RandoGestionnaire.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation

class RandoGestionnaire {
    
    
    private static var sharedRandoGestionnaire: RandoGestionnaire = {
        let randoGestionnaire = RandoGestionnaire()
        
        return randoGestionnaire
    }()
    
    var randos = [Rando]()
    var personnes = [Personne]()
    
    
    // Initialization
    
    private init() {
        let personne = Personne(id: 1, email: "1", lastName: "Sébastien", firstName: "Lamblino", password: "pass");
        let personne2 = Personne(id: 2, email: "2", lastName: "Vadym", firstName: "Lamblino", password: "pass");
        
        let rando1 = Rando(id: 1, name : "Calanque Luminy", description: "Magnifique randonné dans les calanques de Marseille", ville: "Marseille", dateDepart: "20/02/2020", latitude: "43.232230", longitude: "5.435990", owner: personne, persons: [])
        let rando2 = Rando(id: 1, name : "Randonné cool", description: "Magnifique randonné dans Marseille", ville: "Marseille", dateDepart: "20/03/2020", latitude: "43.288593", longitude: "5.370514", owner: personne, persons: [])
        
        randos.append(rando1)
        randos.append(rando2)
        
        personnes.append(personne)
        personnes.append(personne2)
    }
    
    // MARK: - Accessors
    
    class func shared() -> RandoGestionnaire {
        return sharedRandoGestionnaire
    }
    
}
