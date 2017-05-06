//
//  AdidasUser.swift
//  SportShop
//
//  Created by Tejas on 2/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper

class HealthUser: User {

    //var sport: String?
    var imageSource:String?
    var firstname: String?
    var lastname: String?
    var pcp: String?
    var sfId:String?
    var redoxId:String?
    var phone: String?
    
    var fullName:String? {
        if let firstname = firstname, let lastname = lastname {
            return "\(firstname) \(lastname)"
        }
        
        return self.username
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        //sport <- map["sport"]
        imageSource <- map["imageSource"]
        firstname <- map["first_name"]
        lastname <- map["last_name"]
        pcp <- map["pcp"]
        sfId <- map["sf_id"]
        redoxId <- map["redox_id"]
        phone <- map["phone"]
    }
}
