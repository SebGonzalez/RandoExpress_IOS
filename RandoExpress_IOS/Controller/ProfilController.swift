//
//  ProfilController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ProfilController : UIViewController {
    
    @IBOutlet weak var deconnectButton :UIButton!
    
    //var currentPersonne : Personne
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func decoAction() {
        do {
             try AuthGestionnaire.shared().deleteJWT(jwtSave :AuthGestionnaire.shared().jwt ?? "")
        } catch(let error) {
            print(error)
        }
        self.performSegue(withIdentifier: "moveToLogin", sender: self)
    }
    
   
}
