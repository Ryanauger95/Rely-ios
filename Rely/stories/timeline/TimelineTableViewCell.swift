//
//  TimeLineTableViewCell.swift
//  Rely
//
//  Created by Ryan Auger on 7/7/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    

    

    @IBOutlet weak var timelineNameLbl: UILabel!
    @IBOutlet weak var timelineAmountLbl: UILabel!
    @IBOutlet weak var timelineDescription: UITextView!
    @IBOutlet weak var timelineDayLbl: UILabel!
    @IBOutlet weak var timelineImg: UIImageView!
    @IBOutlet weak var timelineStatusIcon: UIImageView!
    @IBOutlet weak var timelineMiddleView: View!
    
    override func layoutSubviews() {
        timelineImg.image = UIImage(named: "default_profile")
        timelineImg.layer.cornerRadius = timelineImg.frame.size.width / 2
        timelineImg.clipsToBounds = true
        
        timelineStatusIcon.layer.cornerRadius = timelineStatusIcon.frame.size.width / 2
        timelineStatusIcon.backgroundColor = UIColor.init(rgb: 0x7FE239)
        timelineStatusIcon.layer.borderColor = UIColor.white.cgColor
        timelineStatusIcon.layer.borderWidth = 1
        timelineStatusIcon.clipsToBounds = true
        
        timelineAmountLbl.textColor = UIColor.gray
        timelineDayLbl.textColor = UIColor.gray        //set cell to initial state here, reset or set values, etc.
        
        timelineDescription.isUserInteractionEnabled = false
        timelineDescription.textContainer.maximumNumberOfLines = 2
        timelineDescription.textContainer.lineBreakMode = .byTruncatingTail
        timelineDescription.textColor = UIColor.gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
