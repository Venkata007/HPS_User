//
//  NewEventTableViewCell.swift
//  HPS_User
//
//  Created by Vamsi on 05/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class NewEventTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDayNameLbl: UILabel!
    @IBOutlet weak var dateLbl: NSLayoutConstraint!
    @IBOutlet weak var bookSeatBtn: UIButton!
    @IBOutlet weak var seeAllBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewInView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.bookSeatBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : self.bookSeatBtn.h / 2)
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.statusLbl, corners: [.topRight], size: CGSize(width: 5, height: 0))
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
