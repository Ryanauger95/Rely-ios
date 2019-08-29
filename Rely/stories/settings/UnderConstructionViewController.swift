//
//  UnderConstructionViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/11/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class UnderConstructionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.styleDarkNav()
        
        self.title = "Under Construction"
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil
        self.navigationController?.navigationBar.isHidden = true

    }
    

    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

