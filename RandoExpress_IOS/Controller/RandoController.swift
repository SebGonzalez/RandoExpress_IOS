//
//  RandoController.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-03 on 29/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit
import MapKit

class RandoController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet var descriptionArea : UITextView!
    @IBOutlet var labelTitle : UITextView!
    @IBOutlet var nbPers : UITextView!
    @IBOutlet var userInfo : UITextView!
    @IBOutlet weak var mapView: MKMapView!
    var rando : Rando!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var latitudeInit: Double = (rando.latitude as NSString).doubleValue
        var longitudeInit: Double = (rando.longitude as NSString).doubleValue
        var coordinateInit :  CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinateInit, span: span)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        mapView.isRotateEnabled = true
        mapView.addAnnotation(Poi(title: rando.name, coordinate: coordinateInit, info: rando.description, Id: Int(rando.id)))
        
        labelTitle.text = rando.name
        descriptionArea.text = rando.description
        userInfo.text = "Information sur le créateur de la randonnée : \n" + rando.owner.firstName + " " + rando.owner.name
        nbPers.text = "Nombre de personnes inscrites: " + String(rando.persons.count)
        print(rando)
    }
    
    
}
