//
//  EventsListModel.swift
//  HPS_Admin
//
//  Created by Hexadots on 12/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventsListModel{
    
    var success : Bool = false
    var events = [EventsData]()
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        if let dataJson = json.dictionary{
            if !dataJson.isEmpty{
                success = true
                for data in dataJson{
                    events.append(EventsData(fromJson: (data.key, data.value)))
                }
                events = events.sorted { (data1, data2) -> Bool in
                    return data1.createdOn < data2.createdOn
                }
                events.reverse()
            }
        }
    }
}

class EventsData{
    
    var eventName:String!
    
    var audit : EventsDataAudit!
    var bookingStatus : String!
    var bookingUserIds = [EventsDataBookingUserId]()
    var closedById : String!
    var closedByName : String!
    var closedAt : String!
    var closedAtNum : String!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    var createdOnNum : String!
    var endedById : String!
    var endedByName : String!
    var endedAt : String!
    var endedAtNum : String!
    var eventEndAt : String!
    var eventEndAtNum : String!
    var eventId : String!
    var eventRewardPoints : Int!
    var eventStartAt : String!
    var eventStartAtNum : String!
    var eventStatus : String!
    var name : String!
    var noOfBuyInsCreatedForTheEvent : Int!
    var seats : EventsDataSeat!
    var startedById : String!
    var startedByName : String!
    var startedAt : String!
    var startsAt : String!
    var endsAt : String!
    var startedAtNum : String!
    var totalEventDurationHrs : Int!
    
    init(fromJson json: (String,JSON)){
        
        eventName = json.0
        
        let auditJson = json.1["audit"]
        if !auditJson.isEmpty{
            audit = EventsDataAudit(fromJson: auditJson)
        }
        bookingStatus = json.1["bookingStatus"].string ?? ""
        let bookingUserIdsJson = json.1["bookingUserIds"]
        if !bookingUserIdsJson.isEmpty{
            for userID in bookingUserIdsJson.dictionaryValue{
                bookingUserIds.append(EventsDataBookingUserId(fromJson: userID))
            }
        }
        closedById = json.1["closedById"].string ?? ""
        closedByName = json.1["closedByName"].string ?? ""
        closedById = json.1["closedAt"].string ?? ""
        closedAtNum = json.1["closedAtNum"].string ?? ""
        createdById = json.1["createdById"].string ?? ""
        createdByName = json.1["createdByName"].string ?? ""
        createdOn = json.1["createdOn"].string ?? ""
        createdOnNum = json.1["createdOnNum"].string ?? ""
        endedById = json.1["endedById"].string ?? ""
        endedByName = json.1["endedByName"].string ?? ""
        endedByName = json.1["endedAt"].string ?? ""
        endedAtNum = json.1["endedAtNum"].string ?? ""
        eventEndAt = json.1["eventEndAt"].string ?? ""
        eventEndAtNum = json.1["eventEndAtNum"].string ?? ""
        eventId = json.1["eventId"].string ?? ""
        eventRewardPoints = json.1["eventRewardPoints"].int ?? 0
        eventStartAt = json.1["eventStartAt"].string ?? ""
        eventStartAtNum = json.1["eventStartAtNum"].string ?? ""
        eventStatus = json.1["eventStatus"].string ?? ""
        name = json.1["name"].string ?? ""
        noOfBuyInsCreatedForTheEvent = json.1["noOfBuyInsCreatedForTheEvent"].int ?? 0
        let seatsJson = json.1["seats"]
        if !seatsJson.isEmpty{
            seats = EventsDataSeat(fromJson: seatsJson)
        }
        startedById = json.1["startedById"].string ?? ""
        startedByName = json.1["startedByName"].string ?? ""
        startedById = json.1["startedAt"].string ?? ""
        startedAtNum = json.1["startedAtNum"].string ?? ""
        startsAt = json.1["startsAt"].string ?? ""
        endsAt = json.1["endsAt"].string ?? ""
        startedAt = json.1["startedAt"].string ?? ""
        totalEventDurationHrs = json.1["totalEventDurationHrs"].int ?? 0
    }
    
    init(fromJsonOnly json: JSON){
        
        let auditJson = json["audit"]
        if !auditJson.isEmpty{
            audit = EventsDataAudit(fromJson: auditJson)
        }
        bookingStatus = json["bookingStatus"].string ?? ""
        let bookingUserIdsJson = json["bookingUserIds"]
        if !bookingUserIdsJson.isEmpty{
            for userID in bookingUserIdsJson.dictionaryValue{
                bookingUserIds.append(EventsDataBookingUserId(fromJson: userID))
            }
        }
        closedById = json["closedById"].string ?? ""
        closedByName = json["closedByName"].string ?? ""
        closedById = json["closedAt"].string ?? ""
        closedAtNum = json["closedAtNum"].string ?? ""
        createdById = json["createdById"].string ?? ""
        createdByName = json["createdByName"].string ?? ""
        createdOn = json["createdOn"].string ?? ""
        createdOnNum = json["createdOnNum"].string ?? ""
        endsAt = json["endsAt"].string ?? ""
        endedById = json["endedById"].string ?? ""
        endedByName = json["endedByName"].string ?? ""
        endedByName = json["endedAt"].string ?? ""
        endedAtNum = json["endedAtNum"].string ?? ""
        eventEndAt = json["eventEndAt"].string ?? ""
        eventEndAtNum = json["eventEndAtNum"].string ?? ""
        eventId = json["eventId"].string ?? ""
        eventRewardPoints = json["eventRewardPoints"].int ?? 0
        eventStartAt = json["eventStartAt"].string ?? ""
        eventStartAtNum = json["eventStartAtNum"].string ?? ""
        eventStatus = json["eventStatus"].string ?? ""
        name = json["name"].stringValue
        noOfBuyInsCreatedForTheEvent = json["noOfBuyInsCreatedForTheEvent"].int ?? 0
        let seatsJson = json["seats"]
        if !seatsJson.isEmpty{
            seats = EventsDataSeat(fromJson: seatsJson)
        }
        startedById = json["startedById"].string ?? ""
        startedByName = json["startedByName"].string ?? ""
        startedById = json["startedAt"].string ?? ""
        startedAtNum = json["startedAtNum"].string ?? ""
        startsAt = json["startsAt"].string ?? ""
        startedAt = json["startedAt"].string ?? ""
        totalEventDurationHrs = json["totalEventDurationHrs"].int ?? 0
    }
}

