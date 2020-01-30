//
//  ProfilController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ProfilController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var currentPersonne : Personne
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(RandoGestionnaire.shared().personnes)
        tableView.estimatedRowHeight = 50.0;
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    //Titres des en-têtes de chaque section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //On récupère le numéro de section concerné
        switch section {
        case 0: return "Détail du compte"
        case 1: return "Paramètres"
        default: return ""
        }
    }
    
    //Nombre de rangées par section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2 //Deux items dans la premiere section
        case 1: return 3 //Un item dans la deuxieme
        default: return 0
        }
    }
    
    //Cellule à l'index concerné
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //On crée une cellule basique
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ProfilViewCell
        //On va lui attribuer un texte en function de sa place
        
        //let pers = RandoGestionnaire.shared().personnes[indexPath.row]
        cell.titre.text = "test"
        return cell
    }
}
