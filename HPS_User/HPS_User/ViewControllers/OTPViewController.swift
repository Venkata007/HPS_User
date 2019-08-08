//
//  OTPViewController.swift
//  HPS_User
//
//  Created by Vamsi on 31/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class OTPViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var newOtpBtn: UIButton!
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var timerLbl: UILabel!
    
    var createdOn : String!
    var createdOnNum : String!
    var otpValue : String!
    var sec : Int!
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.otpTF.text = "0000"
        self.otpTF.defaultTextAttributes.updateValue(25.0,forKey: NSAttributedString.Key.kern.rawValue)
        self.updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
    }
    //MARK:- Update UI
    func updateUI(){
        self.getOTPApiHitting()
    }
    func gettingTimerValue(_ createdOn : String){
        DispatchQueue.main.async(execute: {() -> Void in
            let remValue = Int(TheGlobalPoolManager.getTodayDateString().0.secondsInBetweenDate(TheGlobalPoolManager.getDateFromString(createdOn)))
            print("Rem Seconds ======= ",remValue)
            self.sec = 120 - remValue
            print("Value ======= ",self.sec)
            if (self.sec > 0 && self.sec <= 120){
                if self.timer != nil{
                    self.timer.invalidate()
                    self.timer = nil
                }
                self.otpTF.isHidden = false
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            }else{
                self.timerLbl.text = "OTP Timed Out"
                self.otpTF.isHidden = true
                TheGlobalPoolManager.showToastView("Generate New OTP")
            }
        })
    }
    //MARK:- Timer
    @objc func timerAction() {
        if sec == 01 {
            timer.invalidate()
            timer = nil
            ez.runThisInMainThread {
                self.timerLbl.text = "OTP Timed Out.Get New OTP"
                self.otpTF.isHidden = true
            }
            return
        }
        ez.runThisInMainThread {
            let timer = String(format: "OTP will validate till %02d Sec",self.sec)
            self.timerLbl.text = timer
        }
        sec -= 1
    }
    //MARK:- IB Action Outlets
    @IBAction func newOtpBtn(_ sender: UIButton) {
        if self.timer != nil{
            self.timer.invalidate()
            self.timer = nil
        }
        self.generateOTPApi()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
}
extension OTPViewController{
    //MARK:- Get OTP Api Hitting
    func getOTPApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        APIServices.getUrlSession(urlString: ApiURls.Get_OTP , params: [:], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                print(dict)
                self.createdOn = dict[ApiParams.CreatedOn] as? String
                self.createdOnNum = dict[ApiParams.CreatedOnNum] as? String
                self.otpValue = dict[ApiParams.OtpValue] as? String
                self.otpTF.text = self.otpValue
                self.otpTF.defaultTextAttributes.updateValue(25.0,forKey: NSAttributedString.Key.kern.rawValue)
                self.gettingTimerValue(self.createdOn)
            }else{
                TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
            }
        }
    }
    //MARK:- Generate OTP
    func generateOTPApi(){
        TheGlobalPoolManager.showProgress(self.view, title: ToastMessages.Please_Wait)
        let param = [ ApiParams.CreatedOn:TheGlobalPoolManager.getTodayDateString().1 ,
                                ApiParams.MobileNumber: ModelClassManager.loginModel.data.userId!] as [String : Any]
        
        APIServices.patchUrlSession(urlString: ApiURls.Generate_OTP, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let otpObj = dict.object(forKey: ApiParams.OtpObj) as! [String : AnyObject]
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    self.createdOn = otpObj[ApiParams.CreatedOn] as? String
                    self.createdOnNum = otpObj[ApiParams.CreatedOnNum] as? String
                    self.otpValue = otpObj[ApiParams.OtpValue] as? String
                    self.otpTF.text = self.otpValue
                    self.otpTF.defaultTextAttributes.updateValue(25.0,forKey: NSAttributedString.Key.kern.rawValue)
                    self.gettingTimerValue(self.createdOn)
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
}
