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
    
    // San José Capitale du Costa Rica pour centrer la carte
    var latitudeInit: Double = 9.998784
    var longitudeInit: Double = -84.204007
    var coordinateInit :  CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)
    }
    let locationManager = CLLocationManager()
    var userPosition: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randos = RandoGestionnaire.shared().randos
        
        for r in randos {
            mapView.addAnnotation(Poi(title: r.name, coordinate: CLLocationCoordinate2D(latitude: (r.latitude as NSString).doubleValue, longitude: (r.longitude as NSString).doubleValue), info: r.description))
        }
    }
}
