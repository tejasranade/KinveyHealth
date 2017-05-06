//
//  IDCard.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//
import Foundation
import Kinvey
import ObjectMapper
import Realm

class IDCard: Entity {

    dynamic var plan: String?
    dynamic var provider: String?

    dynamic var groupName: String?
    dynamic var groupNo: String?
    dynamic var subscriberName: String?
    dynamic var subscriberNo: String?

    dynamic var issueDate: String?

    dynamic var officeCopay: String?
    dynamic var specialistCopay: String?
//    dynamic var prevCopay: String?
//    dynamic var emerCopay: String?
//    dynamic var urgentCopay: String?
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "idcards"
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])

        plan <- map["plan"]
        provider <- map["provider"]

        groupName <- map["groupname"]
        groupNo <- map["groupnum"]
        subscriberName <- map["subscriber"]
        subscriberNo <- map["subscribernum"]

        issueDate <- map["issuedate"]

        officeCopay <- map["officecopay"]
        specialistCopay <- map["speccopay"]
//        prevCopay <- map["preventative"]
//        emerCopay <- map["emergency"]
//        urgentCopay <- map["urgent"]
    }
    
}
