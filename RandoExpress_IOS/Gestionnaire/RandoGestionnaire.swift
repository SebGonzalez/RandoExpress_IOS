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
        let personne = Personne(id: 1, name: "Sébastien", firstName: "Lamblino", mail: "lamblino@hotmail.fr", password: "azerty");
        let personne2 = Personne(id: 2, name: "Vadym", firstName: "Lamblino", mail: "lamblino@hotmail.fr", password: "azerty");
        
        let rando1 = Rando(id: 1, name : "Calanque Luminy", description: "Magnifique randonné dans les calanques de Marseille", ville: "Marseille", dateDepart: "20/02/2020", latitude: "43.232230", longitude: "5.435990", owner: personne, persons: [])
        let rando2 = Rando(id: 1, name : "Randonné cool", description: "Magnifique randonné dans Marseille", ville: "Marseille", dateDepart: "20/03/2020", latitude: "43.288593", longitude: "5.370514", owner: personne, persons: [])
        
        /*randos.append(rando1)
        randos.append(rando2)
        
        personnes.append(personne)
        personnes.append(personne2)*/
        
        getRandos()
    }
    
    func getRandos() {
        var done = false;
        
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/randos")!
        var request = URLRequest(url: url)
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AuthGestionnaire.shared().jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let dataResponse = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments)
                print(jsonResponse)
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    print("adios")
                    return
                }
                
                for randoJSON in jsonArray {
                    print("okkhhhhhhhhhhhhhhhhhhhhhhhhhhh")
                    print(randoJSON)
                    self.randos.append(Rando(json: randoJSON)!)
                }
                
            } catch {
                print(error)
            }
            done = true
        }
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
    }
    
    class func shared() -> RandoGestionnaire {
        return sharedRandoGestionnaire
    }
    
}
