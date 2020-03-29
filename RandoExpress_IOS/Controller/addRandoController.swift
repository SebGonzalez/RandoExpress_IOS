//
//  addRandoController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 06/03/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class addRandoController : UIViewController{

    /// Boutons de la barre de navigation.
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!

    /// Les TextFields du formulaire.
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var villeTF: UITextField!
    @IBOutlet weak var dateDepartTF: UITextField!
    @IBOutlet weak var heureDepartTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!

    /// Les Label servant a montrer les erreurs.
    @IBOutlet weak var errorNom: UILabel!
    @IBOutlet weak var errorDescription : UILabel!
    @IBOutlet weak var errorVille: UILabel!
    @IBOutlet weak var errorDateDepart: UILabel!
    @IBOutlet weak var errorHeureDepart: UILabel!
    @IBOutlet weak var errorLongitude: UILabel!
    @IBOutlet weak var errorLatitude: UILabel!

    /// Bouton valider.
    @IBOutlet weak var submitButton: UIButton!

    /// L'utilisateur actuel.
    var currentUser : Personne!

    /// Référence au gestionnaire d'authentification.
    var auth :AuthGestionnaire!

    var lastId: String!
    
    var lastIndex: Int!

    /// Méthode d'initialisation.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorNom.text = ""
        errorDescription.text = ""
        errorVille.text = ""
        errorDateDepart.text = ""
        errorHeureDepart.text = ""
        errorLongitude.text = ""
        errorLatitude.text = ""
    
        listeBouton.image = UIImage(named: "list")
        mapBouton.image = UIImage(named: "map")
        profilBouton.image = UIImage(named: "user")
        
        auth = AuthGestionnaire.shared()

        
        getCurrentUser()
    }

    /**
     Fonction d'action qui appelle la fontion d'ajout de la randonnée addRando quand on appuis sur le bouton valider.
     et l'ajoute a la bonne place dans la liste triée

     - Parameters:
        - _ sender: l'appuis sur le bouton valider
     */
    @IBAction func addRandoAction(_ sender: Any) {
        errorNom.text = ""
        errorDescription.text = ""
        errorVille.text = ""
        errorDateDepart.text = ""
        errorHeureDepart.text = ""
        errorLongitude.text = ""
        errorLatitude.text = ""
        
        addRando()
        print("=========")
        let lastRandoJson = getLastRando(id: self.lastId)
        print(lastRandoJson)
        print("111111111111111")
        lastIndex = RandoGestionnaire.shared().getLastBiggerRandoIndex(rando: Rando(json: lastRandoJson)!)
        print("222222222222222")
        RandoGestionnaire.shared().randos.insert(Rando(json: lastRandoJson)!, at: lastIndex)
        print("333333333333333")
        print("addToList")
        
        self.performSegue(withIdentifier: "addToList", sender: self)
    }

    /// Initialise l'utilisateur actuel dans la variable currentUser.
    func getCurrentUser(){
        var done = false;
        
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/personne/mail/" + auth.getConnectedEmail())!
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
                
                
                guard let json = jsonResponse as? [String: Any] else {
                    print("adios")
                    return
                }
 
                print("uuuuuuuuuuuuuuuuuuuuuuuuuuuu")
                
                print(json)
                
                self.currentUser = Personne(json: json)
                print("nom prenom=" + self.currentUser.firstName + self.currentUser.lastName)
                
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

    /**
     Fonction d'ajout de la randonnée

     - Returns: Retourne un json de type [String: Any].
     */
    func addRando() -> [String: Any] {
        var json = [String: String]()
        var done = false;
        
        // Send HTTP Request to Register user
        let myUrl = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/rando")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(AuthGestionnaire.shared().jwt, forHTTPHeaderField: "Authorization")
        
        let postString = ["name": nameTF.text!,
                          "description": descriptionTF.text!,
                          "ville": villeTF.text!,
                          "dateDepart": dateDepartTF.text!,
                          "heureDepart": heureDepartTF.text!,
                          "latitude": latitudeTF.text!,
                          "longitude": longitudeTF.text!,
                          "owner": [
                                "id": currentUser.id,
                                "firstName": currentUser.firstName,
                                "name": currentUser.lastName,
                                "mail": currentUser.mail,
                                "password": currentUser.password
                                    ] as [String: Any]
                          ] as [String: Any]
        
        //RandoGestionnaire.shared().randos.append(Rando(json: postString)!)
        
        
        var jsonData : Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }
        catch {
            print(error)
        }
        request.httpBody = jsonData
        
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
                print("qklbefuvhqeifuglhqeriguheirmghliughqlgruhiuhseilughqerliuehr")
                self.lastId = json["id"]
                
                print(json)
                print(json["jwt"])
                print(json["message"])
                
            } catch {
                print(error)
            }
            done = true
        }
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return json;
        
    }

    /**
     Récurpère le json de la dernière randonnée ajouté dans la base de données

     - Parameters:
        - id: l'id de la randonnée

     - Returns: retourne un json de la dernière randonnée de type [String: Any].
     */
    func getLastRando(id : String) -> [String: Any]{
        var done = false;
        var lastRandoJson: [String: Any]
        
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/rando/id/\(id)")!
        var request = URLRequest(url: url)
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AuthGestionnaire.shared().jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        lastRandoJson = [:] as [String: Any]
        
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
                
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    print("adios")
                    return
                }
                
                print("json last add =")
                print(jsonArray)
                lastRandoJson = jsonArray
                
            } catch {
                print(error)
            }
            done = true
        }
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return lastRandoJson
        
    }

}
