//
//  BuyInsTableViewCell.swift
//  HPS_User
//
//  Created by Vamsi on 05/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BuyInsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var weekdayEventLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var buyInsLbl: UILabel!
    @IBOutlet weak var cashOutLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.viewInView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.collectionView.register(UINib.init(nibName: "BuyInsCell", bundle: nil), forCellWithReuseIdentifier: "BuyInsCell")
        ez.runThisInMainThread {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 25)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            self.collectionView!.collectionViewLayout = layout
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
