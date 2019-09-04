//
//  RequestTableViewCell.swift
//  Rely
//
//  Created by Ryan Auger on 2/6/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var daysLbl: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.image = UIImage(named: ("default_profile"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        
    }
}
