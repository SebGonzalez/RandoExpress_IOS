//
//  Poi.swift
//  RandoExpress_IOS
//
//  Created by etudiant-mac-02 on 28/01/2020.
//  Copyright © 2020 fr.luminy. All rights reserved.
//

import MapKit
import UIKit
class Poi: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    init(title: String, coordinate: CLLocationCoordinate2D, info:
        String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
