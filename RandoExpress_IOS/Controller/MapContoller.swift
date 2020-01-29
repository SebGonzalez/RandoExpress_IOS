//
//  MapContoller.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView : MKMapView!
    
    // Luminy pour centrer la carte
    var latitudeInit: Double = 43.232230
    var longitudeInit: Double = 5.435990
    var coordinateInit :  CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)
    }
    
    let locationManager = CLLocationManager()
    var userPosition: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        setupMap(coordonnees: coordinateInit, myLat: 3, myLong: 3)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = true
        let randos = RandoGestionnaire.shared().randos
        
        for r in randos {
            mapView.addAnnotation(Poi(title: r.name, coordinate: CLLocationCoordinate2D(latitude: (r.latitude as NSString).doubleValue, longitude: (r.longitude as NSString).doubleValue), info: r.description))
        }
        
        let capitalArea = MKCircle(center: coordinateInit, radius: 5000) // rayon de 5 km
        mapView.addOverlay(capitalArea)
    }
    
    // appellé par le bouton "localise moi"
    func setupMap(coordonnees: CLLocationCoordinate2D, myLat: Double, myLong: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLat , longitudeDelta: myLong)
        let region = MKCoordinateRegion(center: coordonnees, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
   


}
