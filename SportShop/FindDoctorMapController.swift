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
    var doctors: [Doctor]!

    func centerMapOnLocation() {
        let locations = doctors.filter({
            $0.location != nil
        }).map({
            $0.location!
        })
        var coordinateRegion: MKCoordinateRegion
        if locations.count >= 2 {
            let latitudes = locations.map { $0.latitude }
            let longitudes = locations.map { $0.longitude }
            let minLatitude = latitudes.min { $0 < $1 }!
            let maxLatitude = latitudes.min { $0 > $1 }!
            let minLongitude = longitudes.min { $0 < $1 }!
            let maxLongitude = longitudes.min { $0 > $1 }!
            let diffLatitude = maxLatitude - minLatitude
            let diffLongitude = maxLongitude - minLongitude
            let halfDiffLatitude = diffLatitude * 0.5
            let halfDiffLongitude = diffLongitude * 0.5
            let centerLatitude = minLatitude + halfDiffLatitude
            let centerLongitude = minLongitude + halfDiffLongitude
            let diffLatitudeInMeters = CLLocation(latitude: maxLatitude, longitude: 0).distance(from: CLLocation(latitude: minLatitude, longitude: 0))
            let diffLongitudeInMeters = CLLocation(latitude: 0, longitude: maxLongitude).distance(from: CLLocation(latitude: 0, longitude: minLongitude))
            coordinateRegion = MKCoordinateRegionMakeWithDistance(
                CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude),
                diffLatitudeInMeters * 1.1,
                diffLongitudeInMeters * 1.1
            )
        } else {
            coordinateRegion = MKCoordinateRegionMakeWithDistance(
                CLLocationCoordinate2D(latitude: 0, longitude: 0),
                regionRadius * 2.0,
                regionRadius * 2.0
            )
        }
        
        mapView.addAnnotations(doctors)
        
        mapView.delegate = self
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation()
    }

}

extension FindDoctorMapController: MKMapViewDelegate {
    
}
