//
//  modelClass.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 14/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

struct DataDisplayModel:Decodable {
    var name = ""
    var age = ""
    var id = ""
    
    private enum CodingKeys:String,CodingKey
    {
        case name = "Name"
        case age = "Age"
        case id = "Id"
    }
}

class modelDisplay:NSObject
{
    var id = ""
    var name = ""
    var age = ""
    
    init(dic:[String:String])
    {
        self.id = dic["Id"]!
        self.name = dic["Name"]!
        self.age = dic["Age"]!
    }
}

class modelDisplayDefault:NSObject,NSCoding
{
    var id = ""
    var name = ""
    var age = ""
    
    init(dic:[String:String])
    {
        self.id = dic["Id"]!
        self.name = dic["Name"]!
        self.age = dic["Age"]!
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as! String
        self.id = aDecoder.decodeObject(forKey: "Id") as! String
        self.age = aDecoder.decodeObject(forKey: "Age") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(id, forKey: "Id")
        aCoder.encode(age, forKey: "Age")
    }
}

struct placeAddressModel
{
    var address = ""
    var placeId = ""
}

struct Message: Decodable {
    
    var senderId: String!
    var senderImage: String!
    var senderName: String!
    var receiverId: String!
    var message: String!
    var messageType: MessageType!
    var propertyId: String!
    var propertyName: String!
    var isRead: String!
    var createdAt: String!
    var duration: String!
    /*
     private enum CodingKeys: String, CodingKey {
     case senderID = "sender_id"
     case senderImage = "sender_image"
     case senderName = "sender_name"
     case receiverID = "receiver_id"
     case message = "message"
     case messageType = "message_type"
     case propertyID = "property_id"
     case propertyName = "property_name"
     case isRead = "is_read"
     case createdAt = "created_at"
     case duration = "duration"
     }
     */
    
    init(dictionary: NSDictionary) {
        senderId = dictionary["sender_id"] as? String ?? ""
        senderImage = dictionary["sender_image"] as? String ?? ""
        senderName = dictionary["sender_name"] as? String ?? ""
        receiverId = dictionary["receiver_id"] as? String ?? ""
        //message = dictionary["message"] as? String ?? ""
        //print(dictionary["message"] as? String ?? "")
        /*
         var data: Data? = nil
         if let aKey = dictionary["message"] {
         data = "\(aKey)".data(using: .utf8)
         }
         if let aData = data {
         message = String(data: aData, encoding: .nonLossyASCII)
         }
         */
        if let msg = dictionary["message"] as? String {
            message = msg.decode()
        } else {
            message = ""
        }
        let messageType = dictionary["message_type"] as? String ?? "0"
        
        self.messageType = MessageType(rawValue: messageType)
        /*
         if messageType == "1" { self.messageType = .text }
         else if messageType == "2" { self.messageType = .image }
         else if messageType == "3" { self.messageType = .audio }
         else if messageType == "4" { self.messageType = .video }
         else if messageType == "5" { self.messageType = .property }
         else { self.messageType = .unknown }
         */
        propertyId = dictionary["property_id"] as? String ?? ""
        propertyName = dictionary["property_name"] as? String ?? ""
        isRead = dictionary["is_read"] as? String ?? ""
        createdAt = dictionary["created_at"] as? String ?? ""
        duration = dictionary["duration"] as? String ?? ""
    }
}

enum MessageType: String, Codable {
    case unknown    =   "0"
    case text       =   "1"
    case image      =   "2"
    case audio      =   "3"
    case video      =   "4"
    case property   =   "5"
}
