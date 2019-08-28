


//
//  GlobalPool.swift
//  DoorVideoCall
//
//  Created by Harshal Choksi on 4/11/17.
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

import UIKit
import EZSwiftExtensions

let TheGlobalPoolManager = GlobalPool.sharedInstance

class GlobalPool: NSObject {
    typealias AlertCallback = (Bool?) -> ()
    static let sharedInstance = GlobalPool()
    var appName:String = "HPS_User"
    var defaults = UserDefaults.standard
    var deviceToken : String = "DEVICE_TOKEN"
    var instanceIDTokenMessage:String = ""
    let device_id = UIDevice.current.identifierForVendor!.uuidString
    let dispatch = Dispatcher()
    var view:UIView{return (ez.topMostVC?.view)!}
    var vc:UIViewController{return ez.topMostVC!}
    var isAlertDisplaying = false
    var appCheck:AppCheck!
    var appMode = ""
    
    override init() {
        super.init()
        self.checkApp()
    }
    //MARK : - Checking App.
    func checkApp(){
        let bundleID = (Bundle.main.bundleIdentifier)!
        if bundleID == "com.app.HPS-User"{
            appMode = "Development"
        }else if bundleID == "com.ios.HPS-User"{
            appMode = "Production"
        }
        appCheck = AppCheck(rawValue: appMode)
    }
    func showToastView(_ title: String) {
        Toast.init(text: title, duration: 2.0).show()
    }
    func showProgress(_ view: UIView,     title: String) {
        ez.runThisInMainThread {
            let loadingView = MBProgressHUD.init(view: view)
            loadingView?.color = UIColor.white
            loadingView?.activityIndicatorColor = #colorLiteral(red: 0.04705882353, green: 0.7137254902, blue: 0.8470588235, alpha: 1)
            view.addSubview(loadingView!)
            
            loadingView?.tag = 1200
            loadingView?.labelText = title
            loadingView?.labelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            loadingView?.dimBackground = true
            loadingView?.show(true)
        }
    }
    func hideProgess(_ view: UIView) {
        ez.runThisInMainThread {
            var loadingView = view.viewWithTag(1200) as? MBProgressHUD
            if (loadingView != nil) {
                loadingView?.hide(true)
                loadingView?.removeFromSuperview()
                loadingView = nil
            }
        }
    }
    //MARK:- Store in Userdefaults
    func storeInDefaults(_ value:AnyObject, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    //MARK: Retrieve from userdefaults
    func retrieveFromDefaultsFor(_ key:String) -> AnyObject?{
        return UserDefaults.standard.object(forKey: key) as AnyObject
    }
    //MARK: Remove from userdefaults
    func removeFromDefaultsFor(_ key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    //MARK: - UIButton Border and Corner radius
    func buttonMethod(button:UIButton)  {
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth=2.0
        button.layer.cornerRadius=10
    }
    //MARK: - Internet Reachability
    func internetAvailability() -> Bool{
        let reachability = Reachability.forInternetConnection()
        reachability?.startNotifier()
        let status = reachability?.currentReachabilityStatus()
        if(status == NotReachable){
            return false
        }
        else if (status == ReachableViaWiFi){
            //WiFi
            reachability?.stopNotifier()
            return true
        }
        else if (status == ReachableViaWWAN){
            //3G
            reachability?.stopNotifier()
            return true
        }
        return false
    }
    // MARK: - Internet Connection
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
    }
    // MARK: - Converting Total Seconds to hh:mm:ss
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    // MARK: - Counting Age
    func ageCount(_ birthYear: String) -> String {
        let components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let age = Int((components?.year)!) - (birthYear as NSString).integerValue
        return "\(age - 1)"
    }
    //MARK: - Removing Special Characters from string
    func removeSpecialCharactersInArray(_ stringToRemove:String) -> String{
        let string = stringToRemove
        let removeChars = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890,.:!_\'")
        let charArray = string.components(separatedBy:removeChars.inverted) as NSArray
        let removedString = charArray.componentsJoined(by: "")
        return removedString
    }
    //MARK:- UIButton Border and Corner radius
    func cornerAndBorder(_ object:AnyObject, cornerRadius : CGFloat , borderWidth : CGFloat, borderColor:UIColor)  {
        object.layer.borderColor = borderColor.cgColor
        object.layer.borderWidth = borderWidth
        object.layer.cornerRadius = cornerRadius
        object.layer.masksToBounds = true
    }
    //MARK:- corner Radius For Header
    func cornerRadiusForParticularCornerr(_ object:AnyObject,  corners:UIRectCorner,  size:CGSize){
        let path = UIBezierPath(roundedRect:object.bounds,
                                byRoundingCorners:corners,
                                cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        object.layer.mask = maskLayer
    }
    //MARK:- UIAlertController
    func showAlertWith(title:String = "", message:String, singleAction:Bool,  okTitle:String = "Ok", cancelTitle:String = "Cancel", callback:@escaping AlertCallback) {
        self.isAlertDisplaying = true
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: .default) { action -> Void in
            self.isAlertDisplaying = false
            callback(true)
        }
        if !singleAction{
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                self.isAlertDisplaying = false
                callback(false)
            }
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        ez.runThisInMainThread {
            self.vc.presentVC(alertController)
        }
    }
    //MARK: - Get Date From String
    func getDateFromString(_ dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
    //MARK: - Get Today Date String
    func getTodayDateString() -> (Date,String){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date24 = dateFormatter.string(from: date)
        return (date,date24)
    }
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //This formate is input formated .
        if let formateDate = dateFormatter.date(from:string){
            dateFormatter.dateFormat = "EEE dd MMM\n hh:mm a" //Output Formated
            return dateFormatter.string(from: formateDate)
        }
        return string
    }
    func getFormattedDate2(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //This formate is input formated .
        if let formateDate = dateFormatter.date(from:string){
            dateFormatter.dateFormat = "dd-MMM-yy hh:mm a" //Output Formated
            return dateFormatter.string(from: formateDate)
        }
        return string
    }
    //MARK: - Email Validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //MARK: - UIButton Border and Corner radius
    func viewFrameMethod(view:UIView)  {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.themeColor.cgColor
        view.layer.cornerRadius=27
        view.layer.masksToBounds = true
    }
    //MARK: - Text Field Frame and Corner radius
    func textFieldFrame(_ tf: UITextField, placeHolder placeStr: String) {
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 0
        let color = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).cgColor
        tf.attributedPlaceholder = NSAttributedString(string: placeStr, attributes: [NSAttributedStringKey.foregroundColor: color])
        tf.layer.masksToBounds = true
    }
    //MARK: - Label Frame and Corner radius
    func labelFrame(_ label: UILabel) {
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
    }
    //MARK: - Printing JSON Object.
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "")
        } catch let myJSONError {
            print("Error jsonToString",myJSONError)
        }
    }
    //MARK: - Logout Method
    func logout(){
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    //MARK: - Get Top Most VC
    func getTopMostVC() ->UIViewController?{
        let appdel = UIApplication.shared.delegate as! AppDelegate
        var top = appdel.window?.rootViewController!
        while ((top?.presentedViewController) != nil) {
            top = top?.presentedViewController!
            return top
        }
        if top?.presentedViewController == nil{
            return appdel.window?.rootViewController
        }
        return nil
    }
    // MARK: - Days Count
    func getDaysCount(_ dateStr : String) -> (Int,Date){
        let previousDate = dateStr
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")! as TimeZone
        let previousDateFormated : Date? = dateFormatter.date(from: previousDate)
        let difference = currentDate.timeIntervalSince(previousDateFormated!)
        return (Int(difference/(60 * 60 * 24 )),previousDateFormated!)
    }
    //MARK:- NS Attributed Text With Color and Font
    func attributedTextWithTwoDifferentTextsWithFont(_ attr1Text : String , attr2Text : String , attr1Color : UIColor , attr2Color : UIColor , attr1Font : Int , attr2Font : Int , attr1FontName : AppFonts , attr2FontName : AppFonts) -> NSAttributedString{
        let attrs1 = [NSAttributedStringKey.font : UIFont.init(name: attr1FontName.fonts, size: CGFloat(attr1Font))!, NSAttributedStringKey.foregroundColor : attr1Color] as [NSAttributedStringKey : Any]
        let attrs2 = [NSAttributedStringKey.font : UIFont.init(name: attr2FontName.fonts, size: CGFloat(attr2Font))!, NSAttributedStringKey.foregroundColor : attr2Color] as [NSAttributedStringKey : Any]
        let attributedString1 = NSMutableAttributedString(string:attr1Text, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:attr2Text, attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }
}
class UILabelPadded: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

class UITextFieldPadded: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 25)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
class Dispatcher{
    enum DispatchLevel{
        case Main, UserInteractive, UserInitiated, Utility, Background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .Main:             return DispatchQueue.main
            case .UserInteractive:  return DispatchQueue.global(qos: .userInteractive)
            case .UserInitiated:    return DispatchQueue.global(qos: .userInitiated)
            case .Utility:          return DispatchQueue.global(qos: .utility)
            case .Background:       return DispatchQueue.global(qos: .background)
            }
        }
    }
    func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .Main, closure: @escaping () -> Void){
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            closure()
        }
    }
}
//MARK:- UI Button
class ButtonWithShadow: UIButton {
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
}
//MARK:- UI Button Icon Right
class ButtonIconRight: UIButton {
    override func imageRect(forContentRect contentRect:CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = super.titleRect(forContentRect: contentRect).maxX - imageFrame.width
        return imageFrame
    }
    override func titleRect(forContentRect contentRect:CGRect) -> CGRect {
        var titleFrame = super.titleRect(forContentRect: contentRect)
        if (self.currentImage != nil) {
            titleFrame.origin.x  = super.imageRect(forContentRect: contentRect).minX
        }
        return titleFrame
    }
}
