//
//  FindDoctorController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey
import MapKit

class FindDoctorMapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
 
    let regionRadius: CLLocationDistance = 1000
    var doctors = [Doctor]()

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        
        let doctor1 = Doctor()
        doctor1.name = "Victor"
        doctor1.companyName = "Kinvey"
        doctor1.location = GeoPoint(latitude: 21.2827, longitude: -157.8294)
        doctors.append(doctor1)
        
        let doctor2 = Doctor()
        doctor2.name = "Tejas"
        doctor2.companyName = "Kinvey"
        doctor2.location = GeoPoint(latitude: 21.285, longitude: -157.825)
        doctors.append(doctor2)
        
        mapView.addAnnotations(doctors)
        mapView.delegate = self
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
    }
    
}

extension FindDoctorMapController: MKMapViewDelegate {
    
}
