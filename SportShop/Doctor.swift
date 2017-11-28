//
//  Product.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper
import Realm
import MapKit

class Doctor: Entity {
    
    @objc dynamic var name: String?
    @objc dynamic var role: String?
    @objc dynamic var companyName: String?
    @objc dynamic var imageSource: String?
    @objc dynamic var location: GeoPoint?
    @objc dynamic var PostalCode: String?
    @objc dynamic var email: String?
    
    @objc dynamic var city: String?
    @objc dynamic var street: String?
    @objc dynamic var zip: String?
    @objc dynamic var state: String?
    
    var addr2:String? {
        if let city = city, let state = state, let zip = zip {
            return city + " " + state + " " + zip
        }
        
        return " "
    }
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "doctors"
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        name <- map["name"]
        role <- ("roles", map["title"])
        companyName <- map["companyName"]
        imageSource <- map["FullPhotoUrl"]
        location <- ("location", map["_geoloc"])
        PostalCode <- map["PostalCode"]
        city <- map["city"]
        street <- map["street"]
        state <- map["state"]
        zip <- map["zip"]
        
        email <- map["email"]
    }
    
}

extension Doctor: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        guard let location = location else {
            return kCLLocationCoordinate2DInvalid
        }
        
        return CLLocationCoordinate2D(geoPoint: location)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return role
    }
    
}
