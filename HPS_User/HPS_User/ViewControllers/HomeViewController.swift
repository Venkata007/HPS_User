//
//  HomeViewController.swift
//  HPS_User
//
//  Created by Vamsi on 04/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mobileNumLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var redeemBtn: UIButton!
    @IBOutlet weak var gamesPlayedLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var rewardsLlb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.EventsTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.EventsTableViewCell)
        tableView.register(UINib(nibName: XIBNames.BuyInsTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.BuyInsTableViewCell)
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        ModelClassManager.userHomeApiHitting(self) { (success, response) -> (Void) in
            if success{
                if let data = ModelClassManager.userHomeModel.data.userInfo{
                    let photoIDURL = NSURL(string:data.profilePicUrl)!
                    TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
                    self.imgView.sd_setImage(with: photoIDURL as URL, placeholderImage: #imageLiteral(resourceName: "ProfilePlaceholder"), options: .cacheMemoryOnly, completed: nil)
                    self.imgView.contentMode = .scaleAspectFill
                    self.nameLbl.text = data.name!
                    self.emailLbl.text = data.emailId!
                    self.mobileNumLbl.text = data.mobileNumber!
                    self.gamesPlayedLbl.text = data.totalGamesPlayed!.toString
                    self.rewardsLlb.text = data.userRewardPoints!.toString
                    self.balanceLbl.text = "₹ \(data.userBalance!)"
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            }
        }
        self.headerView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 0)
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- IB Action Outlets
    @IBAction func redeemBnn(_ sender: UIButton) {
    }
}
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventsTableViewCell) as! EventsTableViewCell
            cell.balanceLbl.isHidden = true
            cell.seeAllBtn.addTarget(self, action: #selector(self.pushingToUpcomimgEventsVC(_:)), for: .touchUpInside)
            if ModelClassManager.userHomeModel.data.upComingEventInfo == nil{
                cell.noEventsView.isHidden = false
                cell.headerView.isHidden = true
                cell.viewInView.isHidden = true
                cell.statusImgView.isHidden = true
                cell.noEventslbl.text = "No Upcoming Events"
                cell.seeAllBtn.isEnabled = false
            }else{
                cell.noEventsView.isHidden = true
                if let data = ModelClassManager.userHomeModel.data.upComingEventInfo{
                    if data.bookingData == nil{
                        cell.balanceLbl.isHidden =  true
                        cell.bookBtn.isHidden = false
                    }else{
                        cell.balanceLbl.isHidden =  true
                        cell.bookBtn.isHidden = false
                        cell.bookBtn.setTitle("Booked", for: .normal)
                        cell.bookBtn.isEnabled = false
                    }
                    cell.bookingIDLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.eventData.name!)\n", attr2Text: data.eventData.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
                    cell.rewardPointsLbl.text = "\(data.eventData.eventRewardPoints!.toString)\n points"
                    cell.contentLbl.attributedText =  TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Available/Total Seats\n", attr2Text: "\(data.eventData.seats.available!)/\(data.eventData.seats.total!)", attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), attr1Font:16 , attr2Font: 14, attr1FontName: .Bold, attr2FontName: .Bold)
                    switch data.eventData.eventStatus! {
                    case "created":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Created")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.eventData.startsAt!)
                    case "running":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Running")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.eventData.startedAt!)
                    case "finished":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Finish")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.eventData.startedAt!)
                    case "closed":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Closed")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.eventData.startedAt!)
                    default:
                        break
                    }
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventsTableViewCell) as! EventsTableViewCell
            cell.seeAllBtn.addTarget(self, action: #selector(self.pushingToCompletedEventsVC(_:)), for: .touchUpInside)
            cell.bookBtn.isHidden = true
            cell.titleLbl.text = "Completed Events"
            if ModelClassManager.userHomeModel.data.userLastPlayInfo == nil{
                cell.noEventsView.isHidden = false
                cell.headerView.isHidden = true
                cell.viewInView.isHidden = true
                cell.statusImgView.isHidden = true
                cell.noEventslbl.text = "No Completed Events"
                cell.seeAllBtn.isEnabled = false
            }else{
                cell.noEventsView.isHidden = true
                if let data = ModelClassManager.userHomeModel.data.userLastPlayInfo{
                    cell.bookingIDLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.bookingData.eventName!)\n", attr2Text: data.bookingData.bookingId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
                    cell.rewardPointsLbl.text = "\(data.bookingData.eventRewardPoints!.toString)\n points"
                    cell.contentLbl.attributedText =  TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Buy In's/CashOut\n", attr2Text: "₹ \(data.bookingData.totalBuyIns!)/ ₹ \(data.bookingData.cashout!)", attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), attr1Font:16 , attr2Font: 14, attr1FontName: .Bold, attr2FontName: .Bold)
                    cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(data.bookingData.balance!.toString)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                    switch data.bookingData.status! {
                    case "blocked":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Blocked")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinedAt!)
                    case "completed":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Completed")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinedAt!)
                    case "confirmed":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Confirmed")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinsAt!)
                    case "playing":
                        cell.statusImgView.image = #imageLiteral(resourceName: "Playing")
                        cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinedAt!)
                    default:
                        break
                    }
                }
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BuyInsTableViewCell) as! BuyInsTableViewCell
            cell.seeAllBtn.addTarget(self, action: #selector(self.pushingToBuyInsVC(_:)), for: .touchUpInside)
            if let data = ModelClassManager.userHomeModel.data.lastBuyInBookingInfo{
                cell.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.eventName!)\n", attr2Text: data.bookingId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
                cell.pointslbl.text = "\(data.eventRewardPoints!.toString)\n points"
                cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate2(string: data.userJoinsAt!)
                cell.buyInsLbl.text = "₹ \(data.totalBuyIns!)"
                cell.cashOutLbl.text = "₹ \(data.cashout!)"
                cell.totalLbl.text = "₹ \(data.balance!)"
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
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
             if let data = ModelClassManager.userHomeModel.data.lastBuyInBookingInfo{
                if data.buyIns.count == 0{
                    return 210
                }else{
                    return CGFloat(210 + (data.buyIns.count * 30))
                }
             }
        default:
            break
        }
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
//MARK:- Collection View Delegate Methods
extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  ModelClassManager.userHomeModel.data.lastBuyInBookingInfo.buyIns.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyInsCell", for: indexPath as IndexPath) as! BuyInsCell
        cell.serialNoLbl.text = "\(indexPath.row + 1)."
        if let data = ModelClassManager.userHomeModel.data.lastBuyInBookingInfo{
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.buyIns[indexPath.row].createdOn!)
            cell.amountLbl.text = "₹ \(data.buyIns[indexPath.row].amount!)"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}
extension HomeViewController{
    @objc func pushingToCompletedEventsVC(_ btn : UIButton){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.CompletedEventsViewController) as? CompletedEventsViewController{
            ez.topMostVC?.pushVC(viewCon)
        }
    }
    @objc func pushingToUpcomimgEventsVC(_ btn : UIButton){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.UpComingEventsVC) as? UpComingEventsVC{
            ez.topMostVC?.pushVC(viewCon)
        }
    }
    @objc func pushingToBuyInsVC(_ btn : UIButton){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BuyInsViewController) as? BuyInsViewController{
            ez.topMostVC?.pushVC(viewCon)
        }
    }
}
