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
    
    @IBAction func loginAction(_ sender: Any) {
        
        /*
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        */
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
}

