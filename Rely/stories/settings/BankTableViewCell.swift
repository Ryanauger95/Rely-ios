//
//  BankTableViewCell.swift
//  Rely
//
//  Created by Ryan Auger on 7/12/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class BankTableViewCell: UITableViewCell {

    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountView: View!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
