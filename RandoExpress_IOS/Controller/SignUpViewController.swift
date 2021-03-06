//
//  SignUpViewController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 06/02/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class SignUpViewController : UIViewController {

    /// Les TextFields du formulaire.
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!

    /// Les Label servant a montrer les erreurs.
    @IBOutlet weak var errorFirstname: UILabel!
    @IBOutlet weak var errorLastname: UILabel!
    @IBOutlet weak var errorEmail: UILabel!
    @IBOutlet weak var errorPassword: UILabel!
    @IBOutlet weak var errorConnexion: UILabel!

    /// Méthode d'initialisation.
    override func viewDidLoad() {
        super.viewDidLoad()
        errorEmail.text = ""
        errorPassword.text = ""
        errorConnexion.text = ""
        errorFirstname.text = ""
        errorLastname.text = ""
    }

    /**
     Bouton action qui gère la validation du formulaire appel la méthode signUp une fois le formulaire valide

     - Parameters:
        - _ sender: Appuis sur le bouton valider.

     */
    @IBAction func signUpAction(_ sender: Any) {
        errorEmail.text = ""
        errorPassword.text = ""
        errorConnexion.text = ""
        errorFirstname.text = ""
        errorLastname.text = ""
        
        if(!isValidEmail(email.text ?? "") ) {
            errorEmail.text = "Merci d'entrer un mail valide"
            return
        }
        if(!isValidPassword(password.text ?? "")) {
            errorPassword.text = "Merci d'entrer un mot de passe de plus de 5 caractères"
            return
        }
        
        if(firstname.text == "") {
            errorEmail.text = "Merci d'entrer un prénom valide"
            return
        }
        
        
        if(lastname.text == "") {
            errorEmail.text = "Merci d'entrer un nom valide"
            return
        }
       
        
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let json : [String: String] = signup()
            print(json)
            
            if( json["message"] != "Personne ajoutée") {
                errorConnexion.text = json["message"]
                
            }
            else {
                self.performSegue(withIdentifier: "signupToLogin", sender: self)
            }
            
        }
    }

    /// Méthode de validation de l'email.
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    /// Méthode de validation du mot de passe.
    func isValidPassword(_ password: String) -> Bool {
        if(password == "") {
            return false
        }
        if(password.count <= 5) {
            return false
        }
        return true
    }

    /**
     Méthode d'inscription qui envoie le formulaire valide sous forme de json a l'api pour ajouter
     le nouveau user.

     - Returns: retourne un json de type [String: String].
     */
    func signup() -> [String: String] {
        var json = [String: String]()
        var done = false;
        
        // Send HTTP Request to Register user
        let myUrl = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/personne")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["firstName": firstname.text!,
                          "name": lastname.text!,
                          "mail": email.text!,
                          "password": password.text!,
                          ] as [String: String]
        
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
    
}
