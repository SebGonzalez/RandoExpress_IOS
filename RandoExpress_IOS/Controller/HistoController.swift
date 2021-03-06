//
//  HistoController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 10/03/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class HistoController : UIViewController, UITableViewDataSource, UITableViewDelegate{

    /// TableView nous permettant de faire une liste.
    @IBOutlet weak var tableView: UITableView!

    /// Boutons de la barre de navigation.
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!
    
    let cellSpacingHeight: CGFloat = 10

    /// Méthode d'initialisation.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listeBouton.image = UIImage(named: "listo")
        mapBouton.image = UIImage(named: "map")
        profilBouton.image = UIImage(named: "user")
        
        print(RandoGestionnaire.shared().oldRandos.count)
        tableView.estimatedRowHeight = 85.0;
        tableView.rowHeight = UITableView.automaticDimension
    }

    /// Retourne le nombre de randonnée.
    func numberOfSections(in tableView: UITableView) -> Int {
        return RandoGestionnaire.shared().oldRandos.count
    }
    
    /// Gère l'espacement entre les cellules.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    /// Titres des en-têtes de chaque section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    /// Nombre de rangées par section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Cellule à l'index concerné
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //On crée une cellule basique
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! RandoViewCell
        //On va lui attribuer un texte en function de sa place
        
        let rando = RandoGestionnaire.shared().oldRandos[indexPath.section]
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

    /// Permet de nous renvoyer sur la page de la randonnée quand on clique sur sa cellule correspondante
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let randoController = storyboard.instantiateViewController(withIdentifier: "randoc") as! RandoController
        
        randoController.rando = RandoGestionnaire.shared().oldRandos[indexPath.section]
        randoController.oldRando = true
        self.present(randoController, animated: true, completion: nil)
    }
    
}
