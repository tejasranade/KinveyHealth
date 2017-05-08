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
    
    dynamic var deductibleTotal: String?
    dynamic var deductibleRemain: String?
    
    dynamic var deductibleFamilyTotal: String?
    dynamic var deductibleFamilyRemain: String?
    
    
    var individualUsed: Float {
        if let total = deductibleTotal, let remain = deductibleRemain,
            let iTotal = Float(total), let iRemain = Float(remain) {
            return iTotal - iRemain
        }
        return 0
    }
    
    var individualPercentUsed: Float {
        if let total = deductibleTotal, let remain = deductibleRemain,
            let fTotal = Float(total), let fRemain = Float(remain){
            return (fTotal - fRemain)/fTotal
        }
        return 0
    }

    var familyUsed: Float {
        if let total = deductibleFamilyTotal, let remain = deductibleFamilyRemain,
            let iTotal = Float(total), let iRemain = Float(remain) {
            return iTotal - iRemain
        }
        return 0
    }

    var familyPercentUsed: Float {
        if let total = deductibleFamilyTotal, let remain = deductibleFamilyRemain,
            let fTotal = Float(total), let fRemain = Float(remain){
            return (fTotal - fRemain)/fTotal
        }
        return 0
    }
    

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
        
        deductibleTotal <- map["deductible_individual_total"]
        deductibleRemain <- map["deductible_individual_remain"]
        deductibleFamilyTotal <- map["deductible_family_total"]
        deductibleFamilyRemain <- map["deductible_family_remain"]
    }
    
}
