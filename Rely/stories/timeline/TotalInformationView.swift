//
//  TotalInformationView.swift
//  Rely
//
//  Created by Ryan Auger on 9/4/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class TotalInformationView: UIView {
    
    @IBOutlet weak var informationTextView: UITextView!
    var txn: Txn!

    static func instantiate(superView: UIView, txn: Txn) -> TotalInformationView {
        // create the View
        let totalInformationView = Bundle.main.loadNibNamed("TotalInformationView", owner: self, options: nil)?.first as! TotalInformationView
        
        // set properties
        totalInformationView.txn = txn
        totalInformationView.center = superView.center

        return totalInformationView
    }
    
    override func didMoveToSuperview() {
        informationTextView.text = "This total is the amount that the collector is owed on a successful completion and approval of the job. It is the amount paid by the payer ($\(txn.payerTotalString())) minus the fee ($\(txn.totalFeeString()))"
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    

}
