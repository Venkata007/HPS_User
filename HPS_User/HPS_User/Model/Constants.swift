//
//  Constants.swift
//  QHost
//
//  Created by Admin on 29/06/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

let SERVER_IP            = "https://us-central1-home-poker-squad-hps.cloudfunctions.net"
let Auth_Key              = "vYv6I6g2XoC3So3FcuullGwdJrFXss9V2lPJZ3r9"
let USER_INFO          =  "user_info"
 let USER                     =  "user"
let STATUS                 = "status"
let MESSAGE             = "message"
let EVENT_BOOKING_UPDATED = "event-booking-updated"
let EVENT_BOOKING_ADDED = "event-booking-added"
let USER_UPDATED = "user-updated"
let EVENT_UPDATED = "event-updated"
let EVENT_ADDED = "event-added"
let APPROVED = "approved"

public struct Constants {
    static let AppName                = "HPS_User"
    static let TERMS_AND_SERVICES_URL = ""
    static let StoryBoardName         = "Main"
    static let SUCCESS  = "ok"
    static let ERROR = "error"
}
//MARK : - ViewController IDs
public  struct ViewControllerIDs {
    static let LoginViewController                       = "LoginViewController"
    static let RegisterViewController                  = "RegisterViewController"
    static let HomeViewController                      = "HomeViewController"
    static let CompletedEventsViewController = "CompletedEventsViewController"
    static let UpComingEventsVC                        = "UpComingEventsVC"
    static let BuyInsViewController                      = "BuyInsViewController"
    static let BookSeatViewController                 = "BookSeatViewController"
    static let OTPViewController                          = "OTPViewController"
    static let CompletedEventsInfo                     = "CompletedEventsInfo"
    static let LoginNavigationID                           = "LoginNavigationID"
    static let ChangePasswordVC                        = "ChangePasswordVC"
}
//MARK : - Device INFO
public struct DeviceInfo {
    static let DefaultDeviceToken = "2222222"
    static let DeviceType         = "IOS"
    static let Device             = "MOBILE"
}
//MARK : - All Apis
public struct ApiURls{
    static let User_Referral_Verify                    = "\(SERVER_IP)/userReferralVerify"
    static let Register_User                               = "\(SERVER_IP)/registerUser"
    static let Login_User                                    = "\(SERVER_IP)/login"
    static let User_Home                                   = "\(SERVER_IP)/userHome"
    static let Get_All_Events                             = "https://home-poker-squad-hps.firebaseio.com/eventsTable/.json?auth=\(Auth_Key)"
    static let Get_All_Bookings                        = "https://home-poker-squad-hps.firebaseio.com/bookingsTable/.json?auth=\(Auth_Key)"
    static let  Book_Seat                                    = "\(SERVER_IP)/bookSeat"
    static let Get_OTP                                        = "https://home-poker-squad-hps.firebaseio.com/usersTable/\(ModelClassManager.loginModel.data.userId!)/otp/.json?auth=\(Auth_Key)"
    static let Generate_OTP                             = "\(SERVER_IP)/generateOTP"
    static let Update_Password                       = "\(SERVER_IP)/updatePassword"
    static let Logot                                             = "\(SERVER_IP)/logout"
}

// MARK : - Toast Messages
public struct ToastMessages {
    static let  Unable_To_Sign_UP          = "Unable to register now, Please try again...😞"
    static let Check_Internet_Connection   = "Please check internet connection"
    static let Some_thing_went_wrong       = "Something went wrong...🙃, Please try again."
    static let Invalid_Credentials         = "Invalid credentials...🤔"
    static let Success                     = "Success...😀"
    static let Email_Address_Is_Not_Valid  = "Email address is not valid"
    static let Invalid_Email               = "Invalid Email Address"
    static let Invalid_FirstName           = "Invalid Username"
    static let Invalid_Number              = "Invalid Mobile Number"
    static let Invalid_Password            = "Password must contains min 6 character"
    static let Please_Wait                 = "Please wait..."
    static let Password_Missmatch          = "Password Missmatch...😟"
    static let Logout                      = "Logout Successfully...🤚"
    static let Invalid_Latitude            = "Invalid latitude"
    static let Invalid_Longitude           = "Invalid longitude"
    static let Invalid_Address             = "Invalid Address"
    static let Invalid_SelectedAddressType = "Please choose address type"
    static let Invalid_OthersMsg           = "Please give the address type of Others"
    static let Invalid_Strong_Password     = "Password should be at least 6 characters, which Contain At least 1 uppercase, 1 lower case, 1 Numeric digit."
    static let Invalid_OTP                 =  "Invalid OTP"
    static let No_Data_Available           = "No Data Available"
    static let Invalid_Name                = "Invalid Name"
    static let Invalid_Apartmrnt           = "Please enter valid House No/Flat No"
    static let Session_Expired             = "Your session has been expired.Please login again"
    static let Invalid_Ref_Number              = "Invalid Referral Number"
}
//MARK:- XIB Names
public struct XIBNames{
    static let EventsTableViewCell                     =  "EventsTableViewCell"
    static let BuyInsTableViewCell                     =  "BuyInsTableViewCell"
    static let CompletedEventsCell                   =  "CompletedEventsCell"
    static let BuyInsDetailCell                             = "BuyInsDetailCell"
}
//MARK:- Api Paramaters
public struct ApiParams  {
    static let User_Details = "userDetails"
    static let Staus_Code   = "status"
    static let Message      = "message"
    static let MobileNumber = "mobileNumber"
    static let ReferralCode = "referralCode"
    static let Name = "name"
    static let EmailId = "emailId"
    static let CreatedOn = "createdOn"
    static let DeviceId = "deviceId"
    static let Password = "password"
    static let UserType = "type"
    static let User = "user"
    static let UserId = "userId"
    static let EventId = "eventId"
    static let BookFromBlockedSeats = "bookFromBlockedSeats"
    static let UserJoinTime = "userJoinTime"
    static let NewPassword = "newPassword"
    static let ID = "id"
    static let CreatedOnNum = "createdOnNum"
    static let OtpValue = "otpValue"
    static let OtpObj = "otpObj"
}
