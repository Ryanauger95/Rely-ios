//
//  ReserveViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/24/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class ReserveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: 0xFFFFFF, alpha: 0.7)
    }

    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
