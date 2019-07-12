//
//	LoginModel.swift
//	

import Foundation 
import SwiftyJSON

class LoginModel{

	var data : LoginData!
	var message : String!
	var status : String!

	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let dataJson = json["data"]
		if !dataJson.isEmpty{
			data = LoginData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		status = json["status"].string ?? ""
	}
}

class LoginData{
    
    var deviceId : String!
    var emailId : String!
    var mobileNumber : String!
    var name : String!
    var photoIdUrl : String!
    var profilePicUrl : String!
    var referralCode : String!
    var status : String!
    var totalGamesPlayed : Int!
    var totalHoursPlayed : Int!
    var userBalance : Int!
    var userId : String!
    var userRewardPoints : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        deviceId = json["deviceId"].string ?? ""
        emailId = json["emailId"].string ?? ""
        mobileNumber = json["mobileNumber"].string ?? ""
        name = json["name"].string ?? ""
        photoIdUrl = json["photoIdUrl"].string ?? ""
        profilePicUrl = json["profilePicUrl"].string ?? ""
        referralCode = json["referralCode"].string ?? ""
        status = json["status"].string ?? ""
        totalGamesPlayed = json["totalGamesPlayed"].int ?? 0
        totalHoursPlayed = json["totalHoursPlayed"].int ?? 0
        userBalance = json["userBalance"].int ?? 0
        userId = json["userId"].string ?? ""
        userRewardPoints = json["userRewardPoints"].int ?? 0
    }
}
