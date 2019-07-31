//
//  BookSeatViewController.swift
//  HPS_User
//
//  Created by Vamsi on 30/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BookSeatViewController: UIViewController {

    @IBOutlet weak var bookingIDLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rewardPointsLbl: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var coinsImgView: UIImageView!
    @IBOutlet weak var selectSlotView: UIView!
    @IBOutlet weak var selectSlotBtn: UIButton!
    @IBOutlet weak var dropDownImgView: UIImageView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mobileNumLbl: UILabel!
    @IBOutlet weak var bookSeatBtn: UIButton!
    
    var eventsData : EventsData!
    var selectedSlotDate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(BookSeatViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("SlotsCancelClicked"), object: nil)
        self.updateUI()
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 1.5, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
        TheGlobalPoolManager.cornerAndBorder(self.selectSlotView, cornerRadius: 5, borderWidth: 1.5, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
        TheGlobalPoolManager.cornerAndBorder(self.userInfoView, cornerRadius: 5, borderWidth: 1.5, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
        TheGlobalPoolManager.cornerAndBorder(self.profileImgView, cornerRadius: 5, borderWidth: 1.5, borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2048373288))
        self.dropDownImgView.image = #imageLiteral(resourceName: "DropDown").withColor(.white)
        if let data = self.eventsData{
            self.bookingIDLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
            self.rewardPointsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
            self.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
            self.contentLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Available Seats : ", attr2Text: "\(data.seats.available!)", attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 16, attr1FontName: .Bold, attr2FontName: .Medium)
            self.balanceLbl.text = "Total Seats\n\(data.seats.total!)"
            if let data = ModelClassManager.userHomeModel.data.userInfo{
                let photoIDURL = NSURL(string:data.profilePicUrl)!
                self.profileImgView.sd_setImage(with: photoIDURL as URL, placeholderImage: #imageLiteral(resourceName: "ProfilePlaceholder"), options: .cacheMemoryOnly, completed: nil)
                self.profileImgView.contentMode = .scaleAspectFill
                self.nameLbl.text = data.name!
                self.mobileNumLbl.text = data.mobileNumber!
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func selectSlotBtn(_ sender: UIButton) {
        if let data = self.eventsData{
            let endDate = data.endsAt!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let endingDate = dateFormatter.date(from: endDate)
            let modifiedDate = Calendar.current.date(byAdding: .hour, value: -3, to: endingDate!)!
            print(endDate,dateFormatter.string(from: modifiedDate),TheGlobalPoolManager.getTodayDateString())
            let date1 = dateFormatter.date(from: TheGlobalPoolManager.getTodayDateString())
            let date2 = dateFormatter.date(from: dateFormatter.string(from: modifiedDate))
            
            let diff = Date.daysBetween(start: date1!, end: date2!)
            print(diff)

//            if date1 == date2 {
//                TheGlobalPoolManager.showToastView("Oops!,No sloats available right now")
//            }else if date1 > date2 {
//                TheGlobalPoolManager.showToastView("Oops!,No sloats available right now")
//            }else if date1 < date2 {
//                self.selectSlotPopUpView()
//            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
    @IBAction func bookSeatBtn(_ sender: UIButton) {
        if self.selectedSlotDate != nil{
            TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Confirm Booking \nSelected Slot : \(self.selectedSlotDate!)", singleAction: false, okTitle: "Confirm", cancelTitle: "Cancel") { (success) in
                if success!{
                    self.bookSlotApi()
                }
            }
        }else{
            TheGlobalPoolManager.showToastView("Invalid Slot Selected")
        }
    }
}
extension BookSeatViewController : SelectSlotDelegate{
    //MARK: -  Select Slot Pop Up View
    func selectSlotPopUpView(){
        let viewCon = SelectSlotView(nibName: "SelectSlotView", bundle: nil)
        viewCon.eventsData = self.eventsData
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationFade)
    }
    func delegateForSelectedSLot(selectedSlot: String, viewCon: SelectSlotView) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideBottomBottom)
        self.selectedSlotDate = selectedSlot
    }
    //MARK:- Book Slot
    func bookSlotApi(){
        TheGlobalPoolManager.showProgress(self.view, title: ToastMessages.Please_Wait)
        let param = [ ApiParams.UserId: ModelClassManager.loginModel.data.userId!,
                      ApiParams.EventId: self.eventsData.eventId!,
                      ApiParams.CreatedOn: TheGlobalPoolManager.getTodayDateString(),
                      ApiParams.BookFromBlockedSeats: false,
                      ApiParams.UserJoinTime: self.selectedSlotDate] as [String : Any]
        
        APIServices.patchUrlSession(urlString: ApiURls.Book_Seat, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            print(dataResponse.json)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: "status") as! String
                let message = dict.object(forKey: "message") as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    ez.topMostVC?.popVC()
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
}
extension Date {
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
}
