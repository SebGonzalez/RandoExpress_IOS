//
//  ListeController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class ListeController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    /// TableView nous permettant de faire une liste.
    @IBOutlet weak var tableView: UITableView!

    /// Boutons de la barre de navigation.
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!
    
    var roundButton = UIButton()
    let cellSpacingHeight: CGFloat = 10

    /// Méthode d'initialisation.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        RandoGestionnaire.shared().getRandos()
        listeBouton.image = UIImage(named: "listo")?.withRenderingMode(.alwaysOriginal)
        mapBouton.image = UIImage(named: "map")
        profilBouton.image = UIImage(named: "user")
        
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)
        
        print("rando: \(RandoGestionnaire.shared().randos.count)")
        print("rando old:\(RandoGestionnaire.shared().oldRandos.count)")
        tableView.estimatedRowHeight = 85.0;
        tableView.rowHeight = UITableView.automaticDimension
    }

    /// Méthode qui créer le bouton d'ajout d'une randonnée.
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"plus"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    /** Action Handler for button **/
    
    @IBAction func ButtonClick(_ sender: UIButton){
        
        print("nbnbnbnbnbnbnbnbnnbnbnbnbnnbnbnbnbnbnnbnbnbnbnbnbnnbnbb")
        self.performSegue(withIdentifier: "addRandoS", sender: self)
        
    }
    
    
    /// Méthode appelé quand on appuie sur le bouton d'ajout.
    @objc func fbButtonPressed() {
        
        print("B pressed")
    }

    /// Retourne le nombre de randonnée.
    func numberOfSections(in tableView: UITableView) -> Int {
        return RandoGestionnaire.shared().randos.count
    }
    
    // Gère l'espacement entre cellule.
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
        
        let rando = RandoGestionnaire.shared().randos[indexPath.section]
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

        randoController.rando = RandoGestionnaire.shared().randos[indexPath.section]
        self.present(randoController, animated: true, completion: nil)
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
}
