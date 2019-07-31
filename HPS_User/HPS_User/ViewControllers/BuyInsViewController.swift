//
//  BuyInsViewController.swift
//  HPS_User
//
//  Created by Vamsi on 29/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BuyInsViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.BuyInsDetailCell, bundle: nil), forCellReuseIdentifier: XIBNames.BuyInsDetailCell)
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
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
}
extension BuyInsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.getAllBookingsModel == nil ? 0 : ModelClassManager.getAllBookingsModel.bookings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BuyInsDetailCell) as! BuyInsDetailCell
        let data = ModelClassManager.getAllBookingsModel.bookings[indexPath.row]
        cell.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.eventName!)\n", attr2Text: data.bookingId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.pointslbl.text = "\(data.eventRewardPoints!.toString)\n points"
        cell.buyInsLbl.text = "₹ \(data.totalBuyIns!)"
        cell.cashOutLbl.text = "₹ \(data.cashout!)"
        cell.totalLbl.text = "₹ \(data.balance!)"
        switch data.status! {
        case "blocked":
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        case "completed":
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        case "confirmed":
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinsAt!)
        case "playing":
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        default:
            break
        }
        if data.buyIns.count > 0{
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            cell.buyInsTextLbl.text = "₹ \(data.totalBuyIns!)"
        }else{
            cell.buyInsTextLbl.isHidden = true
            cell.buyInsTitleLbl.isHidden = true
            cell.collectionView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = ModelClassManager.getAllBookingsModel.bookings[indexPath.row]
        if data.buyIns.count == 0{
            return 170
        }else{
            return CGFloat(180 + (data.buyIns.count * 30))
        }
    }
}
//MARK:- Collection View Delegate Methods
extension BuyInsViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ModelClassManager.getAllBookingsModel.bookings[section].buyIns.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyInsCell", for: indexPath as IndexPath) as! BuyInsCell
        cell.serialNoLbl.text = "\(indexPath.row + 1)."
        let data = ModelClassManager.getAllBookingsModel.bookings[indexPath.row]
        cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.buyIns[indexPath.row].createdOn!)
        cell.amountLbl.text = "₹ \(data.buyIns[indexPath.row].amount!)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}
