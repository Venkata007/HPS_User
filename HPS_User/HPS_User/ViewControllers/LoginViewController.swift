//
//  LoginViewController.swift
//  HPS_User
//
//  Created by Vamsi on 03/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var viewInViews: [UIView]!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        for view in viewInViews{
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.loginBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius:10, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- Pushing To HomeVC
    func pushingToHomeVC(){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.HomeViewController) as? HomeViewController{
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
    //MARK:- Login Api Hitting
    func loginApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.MobileNumber: self.mobileNumberTF.text!,
                                ApiParams.Password: self.passwordTF.text!,
                                ApiParams.UserType: User,
                                ApiParams.DeviceId: TheGlobalPoolManager.instanceIDTokenMessage] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.Login_User, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: "status") as! String
                let message = dict.object(forKey: "message") as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    ModelClassManager.loginModel = LoginModel.init(fromJson: dataResponse.json)
                    UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: USER_INFO)
                    self.pushingToHomeVC()
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func registerBtn(_ sender: UIButton) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.RegisterViewController) as? RegisterViewController{
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        if loginValidate(){
            self.loginApiHitting()
        }
    }
}
extension LoginViewController{
    func loginValidate() -> Bool{
        if (self.mobileNumberTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }else if (self.passwordTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Password)
            return false
        }
        return true
    }
}
