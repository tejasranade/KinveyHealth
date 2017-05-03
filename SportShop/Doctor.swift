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

class Doctor: Entity {
    dynamic var name: String?
    dynamic var aboutme: String?
    dynamic var companyName: String?
    dynamic var imageSource: String?

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
        name <- map["Name"]
        aboutme <- map["AboutMe"]
        companyName <- map["CompanyName"]
        imageSource <- map["FullPhotoUrl"]
    }
    
}
