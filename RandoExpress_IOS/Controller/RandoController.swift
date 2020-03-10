//
//  RandoController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit
import MapKit

class RandoController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet var descriptionArea : UILabel!
    @IBOutlet var labelTitle : UITextView!
    @IBOutlet var nbPers : UITextView!
    @IBOutlet var userInfo : UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!
    
    @IBOutlet weak var inscriptionButton: UIButton!
    var rando : Rando!
    var inscris = false
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listeBouton.image = UIImage(named: "list")
        mapBouton.image = UIImage(named: "map")
        profilBouton.image = UIImage(named: "user")
        
        var latitudeInit: Double = (rando.latitude as NSString).doubleValue
        var longitudeInit: Double = (rando.longitude as NSString).doubleValue
        var coordinateInit :  CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinateInit, span: span)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        mapView.isRotateEnabled = true
        mapView.addAnnotation(Poi(title: rando.name, coordinate: coordinateInit, info: rando.description, Id: Int(rando.id)))
        
        labelTitle.text = rando.name
        descriptionArea.text = rando.description
        userInfo.text = "Information sur le créateur de la randonnée : \n\(rando.owner.firstName) \(rando.owner.lastName)"
        nbPers.text = "Nombre de personnes inscrites: " + String(rando.persons.count)
        
        let idP = AuthGestionnaire.shared().id;
        print("test")
        print(idP)
        let idInt = UInt(idP);
        print(idInt)
        if(rando.containsPerson(id: idInt ?? 0)) {
            inscriptionButton.setTitle("Se désinscrire", for: .normal)
            inscris = true
        }
        else {
            inscriptionButton.setTitle("S'inscrire", for: .normal)
        }
    }
    
    @IBAction func inscriptionAction() {
         print("OK")
        if(inscris) {
            inscriptionButton.setTitle("S'inscrire", for: .normal)
            inscris = false
            let result = desinscription()
            print(result)
            alert("Résultat :", message: result)
            
            let idP = UInt(AuthGestionnaire.shared().id)
            for i in RandoGestionnaire.shared().randos.indices {
                if(RandoGestionnaire.shared().randos[i].id == rando.id) {
                    var indiceP = -1
                    for y in  RandoGestionnaire.shared().randos[i].persons.indices {
                        if( RandoGestionnaire.shared().randos[i].persons[y].id == idP) {
                            indiceP = y
                        }
                    }
                    RandoGestionnaire.shared().randos[i].persons.remove(at: indiceP)
                     rando.persons.remove(at: indiceP)
                }
            }
             nbPers.text = "Nombre de personnes inscrites: " + String(rando.persons.count)
        }
        else {
            print("Inscription")
            inscriptionButton.setTitle("Se désinscrire", for: .normal)
            inscris = true
            let result = inscription()
            print(result)
            alert("Résultat :", message: result)
            let idP = UInt(AuthGestionnaire.shared().id)
            
            for i in RandoGestionnaire.shared().randos.indices {
                if(RandoGestionnaire.shared().randos[i].id == rando.id) {
                    RandoGestionnaire.shared().randos[i].persons.append(Personne(id: idP ?? 0, lastName: AuthGestionnaire.shared().lastName ?? "", firstName: AuthGestionnaire.shared().firstName ?? "", mail: AuthGestionnaire.shared().email ?? "", password: ""))
                }
            }
            rando.persons.append(Personne(id: idP ?? 0, lastName: AuthGestionnaire.shared().lastName ?? "", firstName: AuthGestionnaire.shared().firstName ?? "", mail: AuthGestionnaire.shared().email ?? "", password: ""))
            nbPers.text = "Nombre de personnes inscrites: " + String(rando.persons.count)
            print(rando)
        }
    }
    
    func inscription() -> String {
       var json = [String: String]()
        var done = false;
    
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/rando/\(rando.id)/inscription/\(AuthGestionnaire.shared().email)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AuthGestionnaire.shared().jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
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
                json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
            } catch {
                print(error)
            }
            done = true
        }
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return json["message"] ?? "";
    }
    
    func desinscription() -> String {
        var json = [String: String]()
        var done = false;
        
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/rando/\(rando.id)/desinscription/\(AuthGestionnaire.shared().email)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AuthGestionnaire.shared().jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
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
                json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
            } catch {
                print(error)
            }
            done = true
        }
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return json["message"] ?? "";
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
}
