//
//  CompletedEventsViewController.swift
//  HPS_User
//
//  Created by Vamsi on 29/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CompletedEventsViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.CompletedEventsCell, bundle: nil), forCellReuseIdentifier: XIBNames.CompletedEventsCell)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        ModelClassManager.getAllBookingsApiHitting(self) { (success, response) -> (Void) in
            if success{
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBnt(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
}
extension CompletedEventsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.getAllBookingsModel == nil ? 0 : ModelClassManager.getAllBookingsModel.bookings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.CompletedEventsCell) as! CompletedEventsCell
        cell.bookBtn.isHidden = true
        let data = ModelClassManager.getAllBookingsModel.bookings[indexPath.row]
        cell.bookingIDLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.eventName!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.rewardPointsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
        cell.contentLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Buy Ins / CashOut\n", attr2Text: "₹ \(data.totalBuyIns!)/₹ \(data.cashout!)", attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 14, attr1FontName: .Bold, attr2FontName: .Medium)
         cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(data.balance!)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
        switch data.status! {
        case "blocked":
            cell.statusImgView.image = #imageLiteral(resourceName: "Blocked")
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        case "completed":
            cell.statusImgView.image = #imageLiteral(resourceName: "Completed")
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        case "confirmed":
            cell.statusImgView.image = #imageLiteral(resourceName: "Confirmed")
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinsAt!)
        case "playing":
            cell.statusImgView.image = #imageLiteral(resourceName: "Playing")
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
