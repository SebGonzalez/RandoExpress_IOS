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

    /// Label d'insformation sur la randonnée.
    @IBOutlet var descriptionArea : UILabel!
    @IBOutlet var labelTitle : UITextView!
    @IBOutlet var nbPers : UITextView!
    @IBOutlet var userInfo : UILabel!

    /// MapView nous affichant l'emplacement de la randonnée.
    @IBOutlet weak var mapView: MKMapView!

    /// Boutons de la barre de navigation.
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!

    /// Bouton d'insription à la randonnée.
    @IBOutlet weak var inscriptionButton: UIButton!
    @IBOutlet weak var groupImage: UIImageView!
    
    var rando : Rando!
    var inscris = false
    var oldRando = false

    /// Méthode d'initialisation.
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
        let idInt = UInt(idP);

       
        inscriptionButton.isEnabled = !oldRando
        
        
        if(rando.containsPerson(id: idInt ?? 0)) {
            inscriptionButton.setTitle("Se désinscrire", for: .normal)
            inscris = true
        }
        else {
            inscriptionButton.setTitle("S'inscrire", for: .normal)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RandoController.imageTapped(gesture:)))
        
        // add it to the image view;
        groupImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        groupImage.isUserInteractionEnabled = true
    }

    /// Méthode action qui change le bouton en "S'inscrire"/"Se désinscrire" et appelle la méthode correspondante
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

    /**
     Méthode d'inscription à la randonnée, où l'on ajoute l'utilisateur actuel à la liste
     des participant.

     - Returns: retourne le message String du json que renvoie l'api.
     */
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

    /**
     Méthode de déinscription de la randonnée, où l'on retire l'utilisateur actuel de la liste
     des participant.

     - Returns: retourne le message String du json que renvoie l'api.
     */
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
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            
            var message = "";
            
            for person in rando.persons {
                message += person.firstName + " " + person.lastName + "\n"
            }
            
            if(rando.persons.count == 0) {
                message = "Aucune personnes encore inscrites"
            }
            
            alert("Membres inscris", message: message)
            
        }
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
}
