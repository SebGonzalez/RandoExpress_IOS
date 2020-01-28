//
//  MapContoller.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit
import MapKit

class MapController : UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapKit : MKMapView!
    
    override func viewDidLoad() {
        
        let citeU = Poi(title: "CiteU luminy", coordinate: CLLocationCoordinate2D(latitude: 43.229490, longitude: 5.438496), info: "Cite universitaire")
        let tortuguero = Poi(title: "Le Redon", coordinate: CLLocationCoordinate2D(latitude: 43.245202, longitude: 5.426947), info: "Arret de bus du Redon")
        
        super.viewDidLoad()
    }
    
}
