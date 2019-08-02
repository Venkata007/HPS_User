//
//  CompletedEventsInfo.swift
//  HPS_User
//
//  Created by Vamsi on 01/08/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CompletedEventsInfo: UIViewController {

    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bookingIDLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rewardPointsLbl: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var coinsImgView: UIImageView!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buyInsTitleLbl: UILabel!
    @IBOutlet weak var buyInsTextLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.register(UINib.init(nibName: "BuyInsCell", bundle: nil), forCellWithReuseIdentifier: "BuyInsCell")
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        ez.runThisInMainThread {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 30)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            self.collectionView!.collectionViewLayout = layout
            self.buyInsTextLbl.isHidden = true
            self.buyInsTitleLbl.isHidden = true
            self.collectionView.isHidden = true
            //self.mainViewHeight.constant = 170
        }
        TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
        if let data = ModelClassManager.userHomeModel.data.userLastPlayInfo{
            self.titleNameLbl.text = data.bookingData.eventName!
            self.bookingIDLbl.text = data.bookingData.bookingId!
            self.rewardPointsLbl.text = data.bookingData.eventRewardPoints!.toString
            self.contentLbl.attributedText =  TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Buy In's/CashOut\n", attr2Text: "₹ \(data.bookingData.totalBuyIns!)/ ₹ \(data.bookingData.cashout!)", attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), attr1Font:16 , attr2Font: 14, attr1FontName: .Bold, attr2FontName: .Bold)
            self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(data.bookingData.balance!.toString)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            switch data.bookingData.status! {
            case "blocked":
                self.statusImgView.image = #imageLiteral(resourceName: "Blocked")
                self.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinedAt!)
            case "completed":
                self.statusImgView.image = #imageLiteral(resourceName: "Completed")
                self.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinedAt!)
            case "confirmed":
                self.statusImgView.image = #imageLiteral(resourceName: "Confirmed")
                self.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinsAt!)
            case "playing":
                self.statusImgView.image = #imageLiteral(resourceName: "Playing")
                self.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.bookingData.userJoinedAt!)
            default:
                break
            }
        }
        ez.runThisInMainThread {
            if let data = ModelClassManager.userHomeModel.data.lastBuyInBookingInfo{
                if data.buyIns.count > 0{
                    self.buyInsTextLbl.isHidden = false
                    self.buyInsTitleLbl.isHidden = false
                    self.collectionView.isHidden = false
                    self.buyInsTextLbl.text = "₹ \(data.totalBuyIns!)"
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                }else{
                    self.mainViewHeight.constant = 170
                    self.buyInsTextLbl.isHidden = true
                    self.buyInsTitleLbl.isHidden = true
                    self.collectionView.isHidden = true
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.popVC()
    }
}
//MARK:- Collection View Delegate Methods
extension CompletedEventsInfo : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  ModelClassManager.userHomeModel.data.lastBuyInBookingInfo.buyIns.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyInsCell", for: indexPath as IndexPath) as! BuyInsCell
        cell.serialNoLbl.text = "\(indexPath.row + 1)."
        if let data = ModelClassManager.userHomeModel.data.lastBuyInBookingInfo{
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate2(string: data.buyIns[indexPath.row].createdOn!)
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
