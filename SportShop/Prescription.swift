//
//  Immunization.swift
//  KinveyHealth
//
//  Created by Tejas on 5/5/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper

class Prescription: Entity {
    
    var name: String?
    var dose: Int?
    var doseUnit: String?
    var freqPeriod: String?
    var freqUnit: String?
    
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "prescriptions"
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        name <- map["name"]
        dose <- map["dose"]
        doseUnit <- map["dose_unit"]
        freqPeriod <- map["freq_period"]
        freqUnit <- map["freq_unit"]
    }
}
