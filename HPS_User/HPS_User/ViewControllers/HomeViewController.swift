//
//  HomeViewController.swift
//  HPS_User
//
//  Created by Vamsi on 04/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mobileNumTF: UILabel!
    @IBOutlet weak var emailBtn: UILabel!
    @IBOutlet weak var redeemBtn: UIButton!
    @IBOutlet weak var gamesPlayedLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var rewardsLlb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.NewEventTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.NewEventTableViewCell)
        tableView.register(UINib(nibName: XIBNames.BuyInsTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.BuyInsTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
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
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.NewEventTableViewCell) as! NewEventTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.NewEventTableViewCell) as! NewEventTableViewCell
            cell.eventName.text = "Your Events"
            cell.eventDayNameLbl.text = "Sat Evng Event"
            cell.statusLbl.text = "Confirmed"
            cell.bookSeatBtn.isHidden = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BuyInsTableViewCell) as! BuyInsTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 315
        default:
            break
        }
        return 150
    }
}
//MARK:- Collection View Delegate Methods
extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyInsCell", for: indexPath as IndexPath) as! BuyInsCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
}
