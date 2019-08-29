//
//  KYCInfoViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/25/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class KYCInfoViewController: UIViewController {

    @IBOutlet weak var kycInfo: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        kycInfo.text = "To comply with Federal Anti-Money Laundering and Terrorism regulation, our banking partner, Evolve Bank and Trust of Memphis TN, must verify certain information.\n\nNOTE: Holdr does not store this data"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
