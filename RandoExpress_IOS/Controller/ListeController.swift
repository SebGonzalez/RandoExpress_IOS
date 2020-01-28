//
//  ListeController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ListeController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    //Titres des en-têtes de chaque section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //On récupère le numéro de section concerné
        switch section {
        case 0: return "Get some help"
        case 1: return "Informations"
        default: return ""
        }
    }
    
    //Nombre de rangées par section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2 //Deux items dans la premiere section
        case 1: return 1 //Un item dans la deuxieme
        default: return 0
        }
    }
    
    //Cellule à l'index concerné
    //Cellule à l'index concerné
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //On crée une cellule basique
        let cell = UITableViewCell(style: .default, reuseIdentifier: "basic")
        //On va lui attribuer un texte en function de sa place
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Contact us"
            } else {
                cell.textLabel?.text = "Visit our Website"
            }
        } else {
            cell.textLabel?.text = "Get more infos"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        alert("Bien joué", message : "T'es un beau gosse")
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
}
