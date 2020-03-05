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
    @IBOutlet weak var changeMdpButton :UIButton!
    @IBOutlet weak var histoButton :UIButton!
    @IBOutlet weak var firstNameLabel :UILabel!
    @IBOutlet weak var lastNameLabel :UILabel!
    @IBOutlet weak var emailLabel :UILabel!
    
    var auth :AuthGestionnaire!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = AuthGestionnaire.shared()
        firstNameLabel.text = auth.getConnectedFirstName()
        lastNameLabel.text = auth.getConnectedLastName()
        emailLabel.text = auth.getConnectedEmail()
    }
    
    @IBAction func decoAction() {
        do {
             try auth.decoFromKeyChain()
        } catch(let error) {
            print(error)
        }
        self.performSegue(withIdentifier: "moveToLogin", sender: self)
    }
    
   
}
