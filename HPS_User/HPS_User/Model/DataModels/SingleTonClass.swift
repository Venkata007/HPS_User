//
//  SingleTonClass.swift
//  UrbanEats
//
//  Created by Hexadots on 02/11/18.
//  Copyright © 2018 Hexadots. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import EZSwiftExtensions

let ModelClassManager = SingleTonClass.sharedInstance
class SingleTonClass: NSObject {

    //Cahce
    let imageCache = SDImageCache.shared()
    var loginModel : LoginModel!
    var userHomeModel : UserHomeModel!
    var eventsListModel : EventsListModel!
    var getAllBookingsModel : GetAllBookingsModel!
    
    class var sharedInstance: SingleTonClass {
        struct Singleton {
            static let instance = SingleTonClass()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
    
    // @@@@@@@@@@@@@  Global Apis Hitting  @@@@@@@@@@@@@@@@@@@@
    // ***** Hitting all the Apis Globally which are used for twice.
    
    //MARK:- Get All Events Api Hitting
    func getAllEventsApiHitting(_ viewCon : UIViewController, loaderStatus : Bool, completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        if !loaderStatus{
            TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        }
        let url = "\(ApiURls.Get_All_Events)&orderBy=%22eventStatus%22&equalTo=%22created%22"
        APIServices.getUrlSession(urlString: url, params: [:], header: HEADER) { (dataResponse) in
            if !loaderStatus{
                TheGlobalPoolManager.hideProgess(viewCon.view)
            }
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                ModelClassManager.eventsListModel  = EventsListModel(fromJson: JSON(dict))
                if ModelClassManager.eventsListModel.success{
                    completionHandler(true,dict as AnyObject)
                }
            }else{
                completionHandler(false,nil)
                if !loaderStatus{
                    TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
                }
            }
        }
    }
    //MARK:- User Home Screen Api Hitting
    func userHomeApiHitting(_ viewCon : UIViewController, loaderStatus : Bool,completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        if !loaderStatus{
            TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        }
        let param = [ ApiParams.UserType : ApiParams.User,
                                ApiParams.UserId: ModelClassManager.loginModel.data.userId!,
                                ApiParams.CreatedOn: TheGlobalPoolManager.getTodayDateString().1] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.User_Home, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            if !loaderStatus{
                TheGlobalPoolManager.hideProgess(viewCon.view)
            }
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    self.userHomeModel = UserHomeModel.init(fromJson: dataResponse.json)
                }else{
                    if !loaderStatus{
                        TheGlobalPoolManager.showToastView(message)
                    }
                }
                completionHandler(true,dict as AnyObject)
            }else{
                completionHandler(false,nil)
                if !loaderStatus{
                    TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
                }
            }
        }
    }
    //MARK:- Get All Bookings Api Hitting
    func getAllBookingsApiHitting(_ viewCon : UIViewController, loaderStatus : Bool, completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        if !loaderStatus{
            TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        }
        let url = "\(ApiURls.Get_All_Bookings)&orderBy=%22userId%22&equalTo=%22\(ModelClassManager.loginModel.data.userId!)%22"
        APIServices.getUrlSession(urlString: url , params: [:], header: HEADER) { (dataResponse) in
            if !loaderStatus{
                TheGlobalPoolManager.hideProgess(viewCon.view)
            }
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                print(dict)
                ModelClassManager.getAllBookingsModel  = GetAllBookingsModel(fromJson: JSON(dict))
                if ModelClassManager.getAllBookingsModel.success{
                    completionHandler(true,dict as AnyObject)
                }
            }else{
                completionHandler(false,nil)
                if !loaderStatus{
                    TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
                }
            }
        }
    }
}

extension SingleTonClass{
    func returnDateFormat(_ dateString:String, fromDateFormat:String, toDateFormat:String) -> String{
        let date = dateString
        let defaultDateFormat = DateFormatter()
        defaultDateFormat.dateFormat = fromDateFormat
        let newFormat = DateFormatter()
        newFormat.calendar = Calendar.init(identifier: Calendar.Identifier.iso8601)
        newFormat.dateFormat = toDateFormat
        if let convertedDate = defaultDateFormat.date(from: date){
            return newFormat.string(from: convertedDate)
        }
        return date
    }
}
