//
//  SlotCell.swift
//  HPS_User
//
//  Created by Vamsi on 30/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class SlotCell: UITableViewCell {

    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellSelected(_ isSelectedValue:Bool){
        if isSelectedValue{
            selectedImg.isHighlighted = true
            self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            selectedImg.isHighlighted = false
            self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
