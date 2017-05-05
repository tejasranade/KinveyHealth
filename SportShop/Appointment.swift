//
//  Appointment.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper
import Realm

class Appointment: Entity {
    var doctor: String?
    var title: String?
    var apptDate: Date?

    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "appointments"
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        doctor <- map["doctor"]
        title <- map["type"]
        apptDate <- (map["apptDate"], KinveyDateTransform())
    }
    
}
//open class CustomDateTransform : TransformType {
//    
//    public typealias Object = Date
//    public typealias JSON = String
//    
//    public init() {}
//    
//    //read formatter that accounts for the timezone
//    lazy var dateReadFormatter: DateFormatter = {
//        let rFormatter = DateFormatter()
//        rFormatter.locale = Locale(identifier: "en_US_POSIX")
//        rFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        return rFormatter
//    }()
//    
//    //read formatter that accounts for the timezone
//    lazy var dateReadFormatterWithoutMilliseconds: DateFormatter = {
//        let rFormatter = DateFormatter()
//        rFormatter.locale = Locale(identifier: "en_US_POSIX")
//        rFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        return rFormatter
//    }()
//    
//    //write formatter for UTC
//    lazy var dateWriteFormatter: DateFormatter = {
//        let wFormatter = DateFormatter()
//        wFormatter.locale = Locale(identifier: "en_US_POSIX")
//        wFormatter.timeZone = TimeZone(identifier: "UTC")
//        wFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        return wFormatter
//    }()
//    
//    open func transformFromJSON(_ value: Any?) -> Date? {
//        if let dateString = value as? String {
//            
//            //Extract the matching date for the following types of strings
//            //yyyy-MM-dd'T'HH:mm:ss.SSS'Z' -> default date string written by this transform
//            //yyyy-MM-dd'T'HH:mm:ss.SSS+ZZZZ -> date with time offset (e.g. +0400, -0500)
//            //ISODate("yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> backward compatible with Kinvey 1.x
//            
//            let matches = self.matches(for: "\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(.\\d{3})?([+-]\\d{4}|Z)", in: dateString)
//            if let match = matches.first {
//                if match.milliseconds != nil {
//                    let value = dateReadFormatter.date(from: match.match)
//                    return value
//                } else {
//                    return dateReadFormatterWithoutMilliseconds.date(from: match.match)
//                }
//            }
//        }
//        return nil
//    }
//    
//    open func transformToJSON(_ value: Date?) -> String? {
//        if let date = value {
//            return dateWriteFormatter.string(from: date)
//        }
//        return nil
//    }
//    
//    typealias TextCheckingResultTuple = (match: String, milliseconds: String?, timezone: String)
//    
//    fileprivate func matches(for regex: String, in text: String) -> [TextCheckingResultTuple] {
//        
//        do {
//            let regex = try NSRegularExpression(pattern: regex)
//            let nsString = text as NSString
//            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
//            return results.map {
//                TextCheckingResultTuple(
//                    match: nsString.substring(with: $0.range),
//                    milliseconds: $0.rangeAt(1).location != NSNotFound ? nsString.substring(with: $0.rangeAt(1)) : nil,
//                    timezone: nsString.substring(with: $0.rangeAt(2))
//                )
//            }
//        } catch let error {
//            //log.error("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//}
