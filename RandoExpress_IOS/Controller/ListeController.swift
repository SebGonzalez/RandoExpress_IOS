//
//  ListeController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ListeController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85.0;
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    //Titres des en-têtes de chaque section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //On récupère le numéro de section concerné
        switch section {
        default: return ""
        }
    }
    
    //Nombre de rangées par section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        default: return 1
        }
    }
    
    //Cellule à l'index concerné
    //Cellule à l'index concerné
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //On crée une cellule basique
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! RandoViewCell
        //On va lui attribuer un texte en function de sa place
        
        let rando = RandoGestionnaire.shared().randos[indexPath.row]
        cell.titre.text = rando.name
        cell.descriptionLabel.text = rando.description
        cell.date.text = rando.dateDepart
        cell.ville.text = rando.ville
        
        // add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let randoController = storyboard.instantiateViewController(withIdentifier: "randoc") as! RandoController

        randoController.rando = RandoGestionnaire.shared().randos[indexPath.row]
        self.present(randoController, animated: true, completion: nil)
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
}
