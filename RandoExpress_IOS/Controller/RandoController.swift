//
//  RandoController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit

class RandoController : UIViewController {
    
    @IBOutlet var descriptionArea : UITextView!
    var rando : Rando!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionArea.text = rando.description
    }
    
    
}
