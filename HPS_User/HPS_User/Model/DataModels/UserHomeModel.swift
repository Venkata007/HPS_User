//
//  UserHomeModel.swift
//  HPS_Admin
//
//  Created by Hexadots on 29/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserHomeModel{
    
    var data : UserHomeData!
    var message : String!
    var status : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = UserHomeData(fromJson: dataJson)
        }
        message = json["message"].string ?? ""
        status = json["status"].string ?? ""
    }
    
}

class UserHomeData{
    
    var lastBuyInBookingInfo : BookingData!
    var upComingEventInfo : UserHomeUpComingEventInfo!
    var userInfo : UserHomeUserInfo!
    var userLastPlayInfo : UserHomeUserLastPlayInfo!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let lastBuyInBookingInfoJson = json["lastBuyInBookingInfo"]
        if !lastBuyInBookingInfoJson.isEmpty{
            lastBuyInBookingInfo = BookingData(fromJson: lastBuyInBookingInfoJson)
        }
        let upComingEventInfoJson = json["upComingEventInfo"]
        if !upComingEventInfoJson.isEmpty{
            upComingEventInfo = UserHomeUpComingEventInfo(fromJson: upComingEventInfoJson)
        }
        let userInfoJson = json["userInfo"]
        if !userInfoJson.isEmpty{
            userInfo = UserHomeUserInfo(fromJson: userInfoJson)
        }
        let userLastPlayInfoJson = json["userLastPlayInfo"]
        if !userLastPlayInfoJson.isEmpty{
            userLastPlayInfo = UserHomeUserLastPlayInfo(fromJson: userLastPlayInfoJson)
        }
    }
    
}

class UserHomeUserInfo{
    
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    var createdOnNum : String!
    var deviceId : String!
    var emailId : String!
    var mobileNumber : String!
    var name : String!
    var password : String!
    var photoIdUrl : String!
    var profilePicUrl : String!
    var referralCode : String!
    var registeredOn : String!
    var registeredOnNum : String!
    var status : String!
    var statusCreatedById : String!
    var statusCreatedByName : String!
    var statusCreatedOn : String!
    var statusCreatedOnNum : String!
    var totalGamesPlayed : Int!
    var totalHoursPlayed : Int!
    var userBalance : Int!
    var userId : String!
    var userRewardPoints : Int!
    var userTotalBuyIns : Int!
    var userTotalCashout : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdById = json["createdById"].string ?? ""
        createdByName = json["createdByName"].string ?? ""
        createdOn = json["createdOn"].string ?? ""
        createdOnNum = json["createdOnNum"].string ?? ""
        deviceId = json["deviceId"].string ?? ""
        emailId = json["emailId"].string ?? ""
        mobileNumber = json["mobileNumber"].string ?? ""
        name = json["name"].string ?? ""
        password = json["password"].string ?? ""
        photoIdUrl = json["photoIdUrl"].string ?? ""
        profilePicUrl = json["profilePicUrl"].string ?? ""
        referralCode = json["referralCode"].string ?? ""
        registeredOn = json["registeredOn"].string ?? ""
        registeredOnNum = json["registeredOnNum"].string ?? ""
        status = json["status"].string ?? ""
        statusCreatedById = json["statusCreatedById"].string ?? ""
        statusCreatedByName = json["statusCreatedByName"].string ?? ""
        statusCreatedOn = json["statusCreatedOn"].string ?? ""
        statusCreatedOnNum = json["statusCreatedOnNum"].string ?? ""
        totalGamesPlayed = json["totalGamesPlayed"].int ?? 0
        totalHoursPlayed = json["totalHoursPlayed"].int ?? 0
        userBalance = json["userBalance"].int ?? 0
        userId = json["userId"].string ?? ""
        userRewardPoints = json["userRewardPoints"].int ?? 0
        userTotalBuyIns = json["userTotalBuyIns"].int ?? 0
        userTotalCashout = json["userTotalCashout"].int ?? 0
    }
    
}

class UserHomeUpComingEventInfo{
    var eventData:EventData!
    var bookingData:BookingData!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        eventData = EventData(fromJson: json["upComingEventInfo"])
        bookingData = BookingData(fromJson: json["upComingBookingInfo"])
    }
}

class UserHomeUserLastPlayInfo{
    var eventData:EventData!
    var bookingData:BookingData!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        eventData = EventData(fromJson: json["eventInfo"])
        bookingData = BookingData(fromJson:  json["bookingInfo"])
    }
}

class UserHomeLastBuyInBookingInfo{
    var bookingData:BookingData!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookingData = BookingData(fromJson:  json["bookingInfo"])
    }
}


class EventData{
    
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
    var startedAtNum : String!
    var totalEventDurationHrs : Int!
    
    init(fromJson json: JSON){
        
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

class BookingData{
    
    var balance : Int!
    var bookingId : String!
    var buyIns = [GetAllBuyIns]()
    var cashoutInfo : CashoutInfo!
    var cashout : Int!
    var createdOn : String!
    var createdOnNum : String!
    var eventId : String!
    var eventName : String!
    var eventRewardPoints : Int!
    var noOfSeatsBookedInEvent : Int!
    var status : String!
    var totalBuyIns : Int!
    var userEventRewardPoints : Int!
    var userId : String!
    var userJoinedAt : String!
    var userJoinedAtNum : String!
    var userJoinsAt : String!
    var userJoinsAtNum : String!
    var userLeftAt : String!
    var userLeftAtNum : String!
    var userName : String!
    var userPlayedHrs : Int!
    
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        balance = json["balance"].int ?? 0
        bookingId = json["bookingId"].string ?? ""
        if let dataJson = json["buyIns"].dictionary{
            if !dataJson.isEmpty{
                //buyIns = []
                for data in dataJson{
                    buyIns.append(GetAllBuyIns(fromJson: (data.key, data.value)))
                }
                buyIns = buyIns.sorted { (data1, data2) -> Bool in
                    return data1.buyInId < data2.buyInId
                }
            }
        }
        cashout = json["cashout"].int ?? 0
        createdOn = json["createdOn"].string ?? ""
        createdOnNum = json["createdOnNum"].string ?? ""
        eventId = json["eventId"].string ?? ""
        eventName = json["eventName"].string ?? ""
        eventRewardPoints = json["eventRewardPoints"].int ?? 0
        noOfSeatsBookedInEvent = json["noOfSeatsBookedInEvent"].int ?? 0
        status = json["status"].string ?? ""
        totalBuyIns = json["totalBuyIns"].int ?? 0
        userEventRewardPoints = json["userEventRewardPoints"].int ?? 0
        userId = json["userId"].string ?? ""
        userJoinedAt = json["userJoinedAt"].string ?? ""
        userJoinedAtNum = json["userJoinedAtNum"].string ?? ""
        userJoinsAt = json["userJoinsAt"].string ?? ""
        userJoinsAtNum = json["userJoinsAtNum"].string ?? ""
        userLeftAt = json["userLeftAt"].string ?? ""
        userLeftAtNum = json["userLeftAtNum"].string ?? ""
        userName = json["userName"].string ?? ""
        userPlayedHrs = json["userPlayedHrs"].int ?? 0
    }
    
}

class GetAllBuyIns {
    
    var amount : Int!
    var buyInId : String!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    
    init(fromJson json: (String,JSON)){
        amount = json.1["amount"].int ?? 0
        buyInId = json.1["buyInId"].string ?? ""
        createdById = json.1["createdById"].string ?? ""
        createdByName = json.1["createdByName"].string ?? ""
        createdOn = json.1["createdOn"].string ?? ""
    }
}


class CashoutInfo{
    
    var amount : Int!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount = json["amount"].int ?? 0
        createdById = json["createdById"].string ?? ""
        createdByName = json["createdByName"].string ?? ""
        createdOn = json["createdOn"].string ?? ""
    }
}

class EventsDataAudit{
    
    var adjustments : Int!
    var otherCharges : Int!
    var rakeAndTips : Int!
    var totalBuyIns : Int!
    var totalUsersBalance : Int!
    var totalcashout : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        adjustments = json["adjustments"].int ?? 0
        otherCharges = json["otherCharges"].int ?? 0
        rakeAndTips = json["rakeAndTips"].int ?? 0
        totalBuyIns = json["totalBuyIns"].int ?? 0
        totalUsersBalance = json["totalUsersBalance"].int ?? 0
        totalcashout = json["totalcashout"].int ?? 0
    }
}

class EventsDataBookingUserId{
    var userID : String!
    var success : Bool!
    init(fromJson json: (String,JSON)){
        userID = json.0
        success = json.1.boolValue
    }
}

class EventsDataSeat{
    
    var available : Int!
    var blocked : Int!
    var booked : Int!
    var total : Int!
    var played : Int!
    var playing : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].int ?? 0
        blocked = json["blocked"].int ?? 0
        booked = json["booked"].int ?? 0
        total = json["total"].int ?? 0
        played = json["played"].int ?? 0
        playing = json["playing"].int ?? 0
    }
}
