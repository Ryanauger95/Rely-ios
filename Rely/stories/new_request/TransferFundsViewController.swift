//
//  TransferFundsViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class TransferFundsViewController: UIViewController {
    @IBOutlet weak var payerTotal: UILabel!
    @IBOutlet weak var RelyHolding: UILabel!
    @IBOutlet weak var payerImageView: UIImageView!
    
    @IBOutlet weak var collectorImageView: UIImageView!
    @IBOutlet weak var collectorTotal: UILabel!
    
    var request : Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let totalStr = String(format: "%.2f", self.request.totalAmount + self.request.reserveAmount)
        self.payerTotal.text = "-$" + totalStr
        self.payerTotal.textColor = UIColor.red
        self.RelyHolding.text = "$0"
        self.RelyHolding.textColor = UIColor.gray
        self.collectorTotal.text = "$0"
        self.collectorTotal.textColor = UIColor.gray

        if self.request.payer.profileImgBase64 != nil {
            self.payerImageView.image = self.request.payer.profileImgBase64?.toUIImage()
        }
        if self.request.collector.profileImgBase64 != nil {
            self.collectorImageView.image = self.request.collector.profileImgBase64?.toUIImage()
        }
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.payerTotal.fadeTransition(0.4)
            self.payerTotal.text = ""
            self.RelyHolding.fadeTransition(0.4)
            self.RelyHolding.textColor = UIColor(rgb: 0x7FE239)
            self.RelyHolding.text = "+$" + totalStr
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }

}
