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
    
    dynamic var name: String?
    dynamic var title: String?
    dynamic var companyName: String?
    dynamic var imageSource: String?
    dynamic var location: GeoPoint?
    dynamic var PostalCode: String?
    dynamic var email: String?
    
    dynamic var city: String?
    dynamic var street: String?
    dynamic var zip: String?
    dynamic var state: String?
    
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
        title <- map["title"]
        companyName <- map["companyName"]
        imageSource <- map["FullPhotoUrl"]
        location <- map["_geoloc"]
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
    
    var subtitle: String? {
        return companyName
    }
    
}
