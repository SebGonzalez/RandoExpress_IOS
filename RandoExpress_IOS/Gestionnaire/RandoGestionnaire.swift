//
//  RandoGestionnaire.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import Foundation

class RandoGestionnaire {
    
    var auth = AuthGestionnaire.shared()
    
    private static var sharedRandoGestionnaire: RandoGestionnaire = {
        let randoGestionnaire = RandoGestionnaire()
        
        return randoGestionnaire
    }()
    
    var randos = [Rando]()
    var oldRandos = [Rando]()
    var personnes = [Personne]()
    
    
    // Initialization
    
    private init() {
        getRandos()
        getOldRandos()
        print("Nombre de randos chargès : ")
        print(randos.count)
        print("Nombre de old randos chargès : ")
        print(oldRandos.count)
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
                    print("aaaaaaaaaaaaaaaaaa")
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
    
    func getOldRandos() {
        var done = false;
        
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/randos/person/old/\(auth.getConnectedId())")!
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
                    print("aaaaaaaaaaaaaaaaaa")
                    self.oldRandos.append(Rando(json: randoJSON)!)
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
    
    func getLastBiggerRandoIndex(rando : Rando) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        var index = 0
        
        var date1 = formatter.date(from: (rando.dateDepart + " " + rando.heureDepart))
        print("1::::::::::::::::::::::::::::::::")
        print(rando.dateDepart + " " + rando.heureDepart)
        print(date1)
        
        for r in randos {
            
            var date2 = formatter.date(from: (r.dateDepart + " " + r.heureDepart))
            print("2::::::::::::::::::::::::::::::::")
            print(r.dateDepart + " " + r.heureDepart)
            print(date2)
            
            if(date1!.compare(date2!) == ComparisonResult.orderedAscending){
                return index
            }
            else{
                index = index + 1
            }
        }
        
        return randos.endIndex
    }
    
    class func shared() -> RandoGestionnaire {
        return sharedRandoGestionnaire
    }
    
}
