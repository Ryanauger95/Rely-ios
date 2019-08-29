//
//  WelcomeViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/28/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Style nav bar
        self.styleClearNav()
        
        // Style buttons
        self.getStartedButton.lightGreenStyle()
        self.signInButton.greenStyle()
        

        // Check to see if the user has previously logged in.
        // If so, send them to the main view controller
        let user = User(defaults: true)
        if user == nil {
            return
        }
       
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)

        
    }
}
