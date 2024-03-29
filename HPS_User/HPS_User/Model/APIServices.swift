//
//  APIServices.swift
//
//  Created by Vamsi on 1/10/17.
//  Copyright © 2017 Vamsi. All rights reserved.
//

/**
 Users/hexadots/Projects/UrbanEater/Pods/Alamofire/Source/Request.swift -------- DataRequest Func
 urlRequest.timeoutInterval = 10.0 // Update TimeInterval for timeout
 Change
 */

import UIKit
import Alamofire
import SwiftyJSON
import EZSwiftExtensions

let HEADER:[String:String] = [:]
let ERROR            = "error"
let RESULT           = "result"
let OBJECT_NOT_FOUND = "Object Not Found"

class APIServices: NSObject {
    // MARK : - Get Api hitting Model
    class func getUrlSession(urlString: String, params: [String : AnyObject] ,header : [String : String] ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        _ = params.printData
        Alamofire.request(urlString,method: .get, parameters: params, headers: header).responseJSON { (response) in
             //_ = response.printData
            if response.json  == JSON.null{
                TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                return
            }
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    _        = response.result.value as! [String : AnyObject]
                    let stautsCode = response.response?.statusCode
                    if (stautsCode)! >= 200 && (stautsCode)! < 300{
                        completionHandler(response)
                    }else{
                        TheGlobalPoolManager.showToastView("No Data Available")
                        TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                    }
                }
                break
            case .failure(_):
                TheGlobalPoolManager.showToastView((response.result.error?.localizedDescription)!)
                TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                break
            }
        }
    }
    // MARK : - Post Api hitting Model
    class func postUrlSession(urlString: String, params: [String : AnyObject] ,header : [String : String] , hideMessage : Bool = false ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        _ = params.printData
        Alamofire.request(urlString,method: .post, parameters: params, encoding : JSONEncoding.default, headers: header).responseJSON { (response) in
            //_ = response.printData
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let dic        = response.result.value as! [String : AnyObject]
                    let stautsCode = response.response?.statusCode
                    let message    = dic[ApiParams.Message] as! String
                    if (stautsCode)! >= 200 && (stautsCode)! < 300{
                        completionHandler(response)
                    }else{
                        TheGlobalPoolManager.showToastView(message)
                        TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                    }
                }
                break
            case .failure(_):
                TheGlobalPoolManager.showToastView((response.result.error?.localizedDescription)!)
                TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                break
            }
        }
    }
    // MARK : - Patch Api hitting Model
    class func patchUrlSession(urlString: String, params: [String : AnyObject] ,header : [String : String] ,  completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        _ = params.printData
        ez.runThisInMainThread {
            Alamofire.request(urlString,method: .patch, parameters: params,encoding : JSONEncoding.default, headers: header).responseJSON { (response) in
                _ = response.printData
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        let dic        = response.result.value as! [String : AnyObject]
                        let stautsCode = response.response?.statusCode
                        let message    = dic[ApiParams.Message] as! String
                        if (stautsCode)! >= 200 && (stautsCode)! < 300{
                            completionHandler(response)
                        }else{
                            TheGlobalPoolManager.showToastView(message)
                            TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                        }
                    }
                    break
                case .failure(_):
                    TheGlobalPoolManager.showToastView((response.result.error?.localizedDescription)!)
                    TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                    break
                }
            }
        }
    }
    // MARK : - Put Api hitting Model
    class func putUrlSession(urlString: String, params: [String : AnyObject] ,header : [String : String] , completion completionHandler:@escaping (_ response: DataResponse<Any>) -> ()) {
        _ = params.printData
        Alamofire.request(urlString,method: .put, parameters: params,encoding : JSONEncoding.default, headers: header).responseJSON { (response) in
            //_ = response.printData
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let dic        = response.result.value as! [String : AnyObject]
                    let stautsCode = response.response?.statusCode
                    let message    = dic[ApiParams.Message] as! String
                    if (stautsCode)! >= 200 && (stautsCode)! < 300{
                        completionHandler(response)
                    }else{
                        TheGlobalPoolManager.showToastView(message)
                        TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                    }
                }
                break
            case .failure(_):
                TheGlobalPoolManager.showToastView((response.result.error?.localizedDescription)!)
                TheGlobalPoolManager.hideProgess((ez.topMostVC?.view)!)
                break
            }
        }
    }
}
extension Dictionary {
    var printData:Any{
        if self.count == 0{
            let jsonObject = [ERROR:OBJECT_NOT_FOUND]
            return TheGlobalPoolManager.jsonToString(json: jsonObject as AnyObject )
        }
        return TheGlobalPoolManager.jsonToString(json: self as AnyObject )
    }
}
extension DataResponse{
    var json:JSON {
        return JSON(self.result.value as Any)
    }
    var dictionary:[String:AnyObject]?{
        return try! JSONSerialization.jsonObject(with: self.result.value as! Data, options: .init(rawValue: 0)) as? [String:AnyObject]
    }
    var dictionaryFromJson:[String:AnyObject]?{
        return self.result.value as? [String:AnyObject]
    }
    var userDetails:[String:AnyObject]?{
        return dictionary?[ApiParams.User_Details] as? [String:AnyObject]
    }
    var userDetailsFromJson:[String:AnyObject]?{
        return dictionaryFromJson?[ApiParams.User_Details] as? [String:AnyObject]
    }
    var printData:Any{
        if self.result.value == nil{
            let jsonObject = [ERROR:self.error?.localizedDescription]
            return TheGlobalPoolManager.jsonToString(json: jsonObject as AnyObject )
        }
        return TheGlobalPoolManager.jsonToString(json: self.result.value as AnyObject )
    }
}
extension JSON{
    var dict:[String:AnyObject]{
        return self.object as! [String : AnyObject]
    }
}
