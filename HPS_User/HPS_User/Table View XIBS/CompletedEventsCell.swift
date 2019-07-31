//
//  CompletedEventsCell.swift
//  HPS_User
//
//  Created by Vamsi on 29/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CompletedEventsCell: UITableViewCell {
    
    @IBOutlet weak var bookingIDLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rewardPointsLbl: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var coinsImgView: UIImageView!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var bannerImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerAndBorder(self.bookBtn, cornerRadius: self.bookBtn.h / 2, borderWidth: 0, borderColor: .clear)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
