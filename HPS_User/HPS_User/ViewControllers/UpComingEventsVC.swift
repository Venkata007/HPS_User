//
//  UpComingEventsVC.swift
//  HPS_User
//
//  Created by Vamsi on 29/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class UpComingEventsVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.CompletedEventsCell, bundle: nil), forCellReuseIdentifier: XIBNames.CompletedEventsCell)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        ModelClassManager.getAllEventsApiHitting(self) { (success, response) -> (Void) in
            if success{
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
}
extension UpComingEventsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.eventsListModel == nil ? 0 : ModelClassManager.eventsListModel.events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.CompletedEventsCell) as! CompletedEventsCell
        cell.balanceLbl.isHidden = true
        cell.bannerImg.isHidden = true
         let data = ModelClassManager.eventsListModel.events[indexPath.row]
        cell.bookingIDLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.rewardPointsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
        cell.contentLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Available / Total Seats\n", attr2Text: "\(data.seats.available!)/\(data.seats.total!)", attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 14, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.bookBtn.tag = indexPath.row
        cell.bookBtn.addTarget(self, action: #selector(pushingToBookSeatVC(_:)), for: .touchUpInside)
        _ = data.bookingUserIds.contains { (value) -> Bool in
            if value.userID! == ModelClassManager.loginModel.data.userId!{
                if value.success == true{
                    cell.bookBtn.isHidden = true
                    cell.balanceLbl.isHidden = false
                    cell.bannerImg.isHidden = false
                    cell.balanceLbl.text = "Booked"
                    return true
                }
            }
            return false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
extension UpComingEventsVC{
    @objc func pushingToBookSeatVC(_ btn : UIButton){
        let data = ModelClassManager.eventsListModel.events[btn.tag]
        if TheGlobalPoolManager.getDateFromString(data.startsAt).isFuture{
            if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookSeatViewController) as? BookSeatViewController{
                viewCon.eventsData = ModelClassManager.eventsListModel.events[btn.tag]
                ez.topMostVC?.pushVC(viewCon)
            }
        }else{
            TheGlobalPoolManager.showToastView("Event Already started")
        }
    }
}
