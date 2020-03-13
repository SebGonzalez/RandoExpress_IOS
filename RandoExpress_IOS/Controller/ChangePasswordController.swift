//
//  ChangePasswordController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 12/03/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ChangePasswordController : UIViewController{
    
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!
    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confPass: UITextField!
    
    @IBOutlet weak var errorOldPass: UILabel!
    @IBOutlet weak var errorNewPass: UILabel!
    @IBOutlet weak var errorConfPass: UILabel!
    @IBOutlet weak var errorChange: UILabel!

    var auth = AuthGestionnaire.shared()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorOldPass.text = ""
        errorNewPass.text = ""
        errorConfPass.text = ""
        errorChange.text = ""
        
        listeBouton.image = UIImage(named: "listo")
        mapBouton.image = UIImage(named: "map")
        profilBouton.image = UIImage(named: "user")

    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        errorOldPass.text = ""
        errorNewPass.text = ""
        errorConfPass.text = ""
        errorChange.text = ""
        
        if(!isValidPassword(newPass.text ?? "")) {
            errorNewPass.text = "Merci d'entrer un mot de passe de plus de 5 caractères"
            return
        }
        
        if newPass.text != confPass.text {
            errorConfPass.text = "Merci d'entrer un mot de passe de plus de 5 caractères"
        }
        
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
    
}
