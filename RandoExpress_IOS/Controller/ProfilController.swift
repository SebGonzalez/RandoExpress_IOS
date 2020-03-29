//
//  ProfilController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ProfilController : UIViewController {

    /// Bouton de déconnexion.
    @IBOutlet weak var deconnectButton :UIButton!

    /// Bouton de changement de mot de passe.
    @IBOutlet weak var changeMdpButton :UIButton!

    /// Bouton d'historique.
    @IBOutlet weak var histoButton :UIButton!

    /// Label d'information affichant le prénom, le nom et l'email de l'utilisateur.
    @IBOutlet weak var firstNameLabel :UILabel!
    @IBOutlet weak var lastNameLabel :UILabel!
    @IBOutlet weak var emailLabel :UILabel!

    /// Boutons de la barre de navigation.
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!

    /// Référence au gestionnaire d'authentification.
    var auth :AuthGestionnaire!

    /// Méthode d'initialisation.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listeBouton.image = UIImage(named: "list")
        mapBouton.image = UIImage(named: "map")
        profilBouton.image = UIImage(named: "usero")?.withRenderingMode(.alwaysOriginal)
        
        auth = AuthGestionnaire.shared()
        firstNameLabel.text = auth.getConnectedFirstName()
        print(firstNameLabel.text)
        lastNameLabel.text = auth.getConnectedLastName()
        emailLabel.text = auth.getConnectedEmail()
    }

    /// Méthode action qui nous déconnecte lorsqu'on appuie sur le bouton de déconnexion.
    @IBAction func decoAction() {
        do {
             try auth.decoFromKeyChain()
        } catch(let error) {
            print(error)
        }
        self.performSegue(withIdentifier: "moveToLogin", sender: self)
    }
    
   
}
