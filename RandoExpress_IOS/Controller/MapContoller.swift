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
    
    @IBOutlet var listeBouton: UIBarButtonItem!
    @IBOutlet var mapBouton: UIBarButtonItem!
    @IBOutlet var profilBouton: UIBarButtonItem!
    
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
        
        listeBouton.image = UIImage(named: "list")
        mapBouton.image = UIImage(named: "mapo")?.withRenderingMode(.alwaysOriginal)
        profilBouton.image = UIImage(named: "user")
        
        print("getPosition")
        if userPosition != nil {
            setupMap(coordonnees: userPosition!.coordinate, myLat: 0.5, myLong: 0.5)
        } else {
            setupMap(coordonnees: coordinateInit, myLat: 0.5, myLong: 0.5)
        }
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = true
        
        mapView.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        
        
        // ajout repère
        let randos = RandoGestionnaire.shared().randos
        
        for r in randos {
            mapView.addAnnotation(Poi(title: r.name, coordinate: CLLocationCoordinate2D(latitude: (r.latitude as NSString).doubleValue, longitude: (r.longitude as NSString).doubleValue), info: r.description, Id: Int(r.id)))
        }
        
        let capitalArea = MKCircle(center: coordinateInit, radius: 5000) // rayon de 5 km
        mapView.addOverlay(capitalArea)
    }
    
    // enrichir les annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Poi else { return nil }
        let identifier = "poi"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    // placer le titre et l'info du Poi dans l'alerte
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let poi = view.annotation as? Poi else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //On crée une instance d'Exercice à partir du storyboard
        let randoController = storyboard.instantiateViewController(withIdentifier: "randoc") as! RandoController
        //On lui attribue le niveau en fonction du bouton
        randoController.rando = RandoGestionnaire.shared().randos[poi.Id]
        self.present(randoController, animated: true, completion: nil)
    }
    
    @IBAction func ChangeMapTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : mapView.mapType = MKMapType.standard
        case 1 : mapView.mapType = .satellite
        case 2 : mapView.mapType = .hybrid
        default: break
        }
    }
    
    // appellé par le bouton "localise moi"
    func setupMap(coordonnees: CLLocationCoordinate2D, myLat: Double, myLong: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLat , longitudeDelta: myLong)
        let region = MKCoordinateRegion(center: coordonnees, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func getPosition(_ sender: Any) {
        print("getPosition")
        if userPosition != nil {
            setupMap(coordonnees: userPosition!.coordinate, myLat: 0.5, myLong: 0.5)
        } else {
            print("nil dans getPosition")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    // si mise à jour des locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let maPosition = locations.last {
                userPosition = maPosition
            }
        }
    }
}
