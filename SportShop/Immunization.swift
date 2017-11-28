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

class Immunization: Entity {
    
    @objc dynamic var name: String?
    @objc dynamic var lastAdministered: String?
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "immunizations"
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        name <- map["name"]
        lastAdministered <- map["last_administered"]
    }
}
