//
//  LoginViewController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 06/02/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorEmail: UILabel!
    @IBOutlet weak var errorPassword: UILabel!
    @IBOutlet weak var errorConnexion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorEmail.text = ""
        errorPassword.text = ""
        errorConnexion.text = ""
    }
    
    @IBAction func loginAction(_ sender: Any) {
        errorEmail.text = ""
        errorPassword.text = ""
        errorConnexion.text = ""
        
        if(!isValidEmail(email.text ?? "") ) {
            errorEmail.text = "Merci d'entrer un mail valide"
            return
        }
        if(!isValidPassword(password.text ?? "")) {
            errorPassword.text = "Merci d'entrer un mot de passe de plus de 5 caractères"
            return
        }
        
        let json : [String: String] = login()
        print("ok")
        print(json)
        
        if( json["message"] != "Connexion validé") {
            errorConnexion.text = json["message"]
        }
        else {
            do {
                try AuthGestionnaire.shared().saveJWT(jwtSave: json["jwt"] ?? "")
                try AuthGestionnaire.shared().savePerson(firstName: json["firstnName"] ?? "", lastName: json["name"] ?? "", email: json["mail"] ?? "", id: json["id"] ?? "")
            } catch(let error) {
                print(error)
            }
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        if(password == "") {
            return false
        }
        if(password.count <= 5) {
            return false
        }
        return true
    }
    
    func login() -> [String: String] {
        var json = [String: String]()
        var done = false;
        
        let url = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/auth")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "mail": email.text ?? "",
            "password": password.text ?? ""
        ]
        var jsonData : Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
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

