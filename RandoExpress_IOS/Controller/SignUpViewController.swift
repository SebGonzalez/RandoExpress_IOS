//
//  SignUpViewController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 06/02/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var errorFirstname: UILabel!
    @IBOutlet weak var errorLastname: UILabel!
    @IBOutlet weak var errorEmail: UILabel!
    @IBOutlet weak var errorPassword: UILabel!
    @IBOutlet weak var errorConnexion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorEmail.text = ""
        errorPassword.text = ""
        errorConnexion.text = ""
        errorFirstname.text = ""
        errorLastname.text = ""
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        errorEmail.text = ""
        errorPassword.text = ""
        errorConnexion.text = ""
        errorFirstname.text = ""
        errorLastname.text = ""
        
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            /*
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            
            }
            */
            self.performSegue(withIdentifier: "signupToHome", sender: self)
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
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("Sign up button tapped")
        
        // Validate required fields are not empty
        if (firstname.text?.isEmpty)! ||
            (lastname.text?.isEmpty)! ||
            (email.text?.isEmpty)! ||
            (password.text?.isEmpty)!
        {
            // Display Alert message and return
            //displayMessage(userMessage: "All fields are quired to fill in")
            return
        }
        
        // Validate password
        if ((password.text?.elementsEqual(passwordConfirm.text!))! != true)
        {
            // Display alert message and return
            //displayMessage(userMessage: "Please make sure that passwords match")
            return
        }
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        // Send HTTP Request to Register user
        let myUrl = URL(string: "http://localhost:8080/RandoExpress_API/ws/rest/personne")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["firstName": firstname.text!,
                          "lastName": lastname.text!,
                          "email": email.text!,
                          "password": password.text!,
                          ] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            //displayMessage(userMessage: "Something went wrong. Try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            //self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    
                    let userId = parseJSON["userId"] as? String
                    print("User id: \(String(describing: userId!))")
                    
                    if (userId?.isEmpty)!
                    {
                        // Display an Alert dialog with a friendly error message
                        //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    } else {
                        //self.displayMessage(userMessage: "Successfully Registered a New Account. Please proceed to Sign in")
                    }
                    
                } else {
                    //Display an Alert dialog with a friendly error message
                    //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
            } catch {
                
                //self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                // Display an Alert dialog with a friendly error message
                //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
        }
        
        task.resume()
        
    }
    
}
