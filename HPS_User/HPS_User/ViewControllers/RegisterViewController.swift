//
//  RegisterViewController.swift
//  HPS_User
//
//  Created by Vamsi on 03/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class RegisterViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var viewsInView: [UIView]!
    @IBOutlet weak var docView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var docUploadBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailIDTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    //Refferal View
    @IBOutlet weak var referralBgView: UIView!
    @IBOutlet weak var referralViewInView: UIView!
    @IBOutlet weak var ref_MobileNumTF: UITextField!
    @IBOutlet weak var referralCodeTF: UITextField!
    @IBOutlet weak var ref_BackBtn: UIButton!
    @IBOutlet weak var ref_VerifyBtn: UIButton!
    
    var selectedImage :UIImage!
    var selectedImageData : NSData!
    var selectedDocImage :UIImage!
    var selectedDocImageData : NSData!
    var isSelectedProfieUploadBtn : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        for view in viewsInView{
            TheGlobalPoolManager.cornerAndBorder(view, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.registerBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.docView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius:10, borderWidth: 0, borderColor: .clear)
        
        //Referral View
         TheGlobalPoolManager.cornerAndBorder(self.ref_MobileNumTF, cornerRadius:5, borderWidth: 1.5, borderColor: .lightGray)
        TheGlobalPoolManager.cornerAndBorder(self.referralCodeTF, cornerRadius:5, borderWidth: 1.5, borderColor: .lightGray)
        self.ref_BackBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.ref_VerifyBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.referralViewInView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 10)
    }
    //MARK:- Validating Referral Code
    func validatingReferralCodeApi(){
        TheGlobalPoolManager.showProgress(self.view, title: ToastMessages.Please_Wait)
        let param = [ ApiParams.MobileNumber: self.ref_MobileNumTF.text!,
                                ApiParams.ReferralCode: self.referralCodeTF.text!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.User_Referral_Verify, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: "status") as! String
                let message = dict.object(forKey: "message") as! String
                if status == Constants.SUCCESS{
                    self.referralBgView.isHidden = true
                    self.mobileNumTF.text = self.ref_MobileNumTF.text
                    TheGlobalPoolManager.showToastView(message)
                }else{
                    self.referralBgView.isHidden = false
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- Validating Referral Code
    func registerUserApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.MobileNumber: self.ref_MobileNumTF.text!,
                                ApiParams.ReferralCode: self.referralCodeTF.text!,
                                ApiParams.Name: self.nameTF.text!,
                                ApiParams.EmailId: self.emailIDTF.text!,
                                ApiParams.CreatedOn: TheGlobalPoolManager.getTodayDateString(),
                                ApiParams.DeviceId: TheGlobalPoolManager.device_id,
                                ApiParams.Password: self.passwordTF.text!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.Register_User, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: "status") as! String
                let message = dict.object(forKey: "message") as! String
                if status == Constants.SUCCESS{
                    ez.topMostVC?.popVC()
                    TheGlobalPoolManager.showToastView(message)
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func registerBtn(_ sender: UIButton) {
        if registerValidate(){
            let fileName = self.ref_MobileNumTF.text!
            let profileName = fileName + "_profilePic"
            TheGlobalPoolManager.showProgress(self.view, title: "Uploading Profile Pic")
            self.uploadImagesToFirebase(imageData: self.selectedImageData as Data, fileName: profileName) { (success) in
                if success{
                    TheGlobalPoolManager.hideProgess(self.view)
                    let photoId = fileName + "_photoId"
                    TheGlobalPoolManager.showProgress(self.view, title: "Uploading Document")
                    self.uploadImagesToFirebase(imageData: self.selectedDocImageData as Data, fileName: photoId, completionHandler: { (success1) in
                        if success1{
                            TheGlobalPoolManager.hideProgess(self.view)
                            self.registerUserApiHitting()
                        }
                    })
                }
            }
        }
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
    @IBAction func docUploadBtn(_ sender: UIButton) {
        self.isSelectedProfieUploadBtn = false
        self.imagePicking("Upload Document")
    }
    @IBAction func uploadBtn(_ sender: UIButton) {
        self.isSelectedProfieUploadBtn = true
         self.imagePicking("Upload Profile Pic")
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
    @IBAction func ref_BackBtn(_ sender: UIButton) {
         ez.topMostVC?.popVC()
    }
    @IBAction func ref_VerifyBtn(_ sender: UIButton) {
        if self.referralCodeValidate(){
            self.validatingReferralCodeApi()
        }
    }
}
extension RegisterViewController  : UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate{
    //MARK: - Image Picking
    func imagePicking(_ title:String){
        let actionSheetController = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        
        let cameraActionButton = UIAlertAction(title: "Take a picture", style: .default) { action -> Void in
            self.imagePicker(clickedButtonat: 0)
        }
        let photoAlbumActionButton = UIAlertAction(title: "Camera roll", style: .default) { action -> Void in
            self.imagePicker(clickedButtonat: 1)
        }
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cameraActionButton)
        actionSheetController.addAction(photoAlbumActionButton)
        actionSheetController.addAction(cancelActionButton)
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("IPAD")
            actionSheetController.modalPresentationStyle = .popover
            let popover = actionSheetController.popoverPresentationController!
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
            self.present(actionSheetController, animated: true, completion: nil )
        }
        else if UIDevice.current.userInterfaceIdiom == .phone{
            print("IPHONE")
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    // MARK: - Image picker from gallery and camera
    private func imagePicker(clickedButtonat buttonIndex: Int) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        switch buttonIndex {
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                present(picker, animated: true, completion: nil)
            }
            else{
                print("Camera not available....")
            }
        case 1:
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion:nil)
        default:
            break
        }
    }
    // MARK: - UIImagePickerController delegate methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if isSelectedProfieUploadBtn{
                selectedImage = image
            }else{
                selectedDocImage = image
            }
        }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if isSelectedProfieUploadBtn{
                selectedImage = image
            }else{
                selectedDocImage = image
            }
        }else{
            print("Something went wrong")
        }
        if isSelectedProfieUploadBtn{
            self.imgView.image = selectedImage
            self.selectedImageData = convertImage(image: selectedImage)
            print(selectedImage)
        }else{
            self.docImgView.image = selectedDocImage
            self.selectedDocImageData = convertImage(image: selectedDocImage)
            print(selectedDocImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func convertImage(image: UIImage) ->NSData {
        let imageData = UIImageJPEGRepresentation(image, 0.1)! as NSData
        return imageData
    }
    func uploadImagesToFirebase(imageData:Data, fileName:String, completionHandler:@escaping (_ response:Bool) -> ()){
        var url = URLRequest(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/home-poker-squad-hps.appspot.com/o/\(fileName).jpg?alt=media")!)
        url.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        url.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        url.httpBody = self.createBody(parameters: [:],boundary: boundary,data: imageData as Data,mimeType: "image/jpg",filename: "\(fileName).jpg")
        let session = URLSession.shared
        let task = session.dataTask(with: url as URLRequest) {data,response,error in
            if error != nil {
                print("error=\(String(describing: error?.localizedDescription))")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(responseString!)
            completionHandler(true)
        }
        task.resume()
    }
    func createBody(parameters: [String: String],boundary: String,data: Data,mimeType: String, filename: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }
}
extension RegisterViewController{
    func referralCodeValidate() -> Bool{
        if (self.ref_MobileNumTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }else if (self.referralCodeTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Ref_Number)
            return false
        }
        return true
    }
    func registerValidate() -> Bool{
        if (self.selectedImageData == nil){
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }else if (self.ref_MobileNumTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }else if (self.referralCodeTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Ref_Number)
            return false
        }else if (self.nameTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Name)
            return false
        }else if (self.emailIDTF.text?.isEmpty)! || !(self.emailIDTF.text?.isEmail)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Email_Address_Is_Not_Valid)
            return false
        }else if (self.mobileNumTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }else if (self.passwordTF.text?.isEmpty)! || !(self.passwordTF.text?.isPasswordValid)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Password)
            return false
        }else if (self.selectedDocImageData == nil){
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }
        return true
    }
    //MARK:- Status Bar Appearence
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
