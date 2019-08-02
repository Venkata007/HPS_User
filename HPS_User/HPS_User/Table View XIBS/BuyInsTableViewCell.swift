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

    @IBOutlet weak var pointslbl: UILabel!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var buyInsLbl: UILabel!
    @IBOutlet weak var cashOutLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var buyInsTextLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buyInsTitleLbl: UILabel!
    @IBOutlet weak var noBuyInsStsLbl: UILabel!
    @IBOutlet weak var noBuyInsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.collectionView.register(UINib.init(nibName: "BuyInsCell", bundle: nil), forCellWithReuseIdentifier: "BuyInsCell")
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
            TheGlobalPoolManager.cornerAndBorder(self.noBuyInsView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 30)
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
