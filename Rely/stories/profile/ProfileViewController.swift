//
//  ProfileViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/8/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class ProfileViewController: ImagePickerViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var accountBalanceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleDarkNav()
        self.title = "Profile"
        
        guard User(defaults: true) != nil else {return}

        self.firstNameTextField.text = self.user.firstName
        self.lastNameTextField.text = self.user.lastName
        self.emailTextField.text = self.user.email
        let profileImg = self.user.profileImgBase64?.toUIImage()
        self.profilePicImageView.image =
            (profileImg != nil) ? profileImg : UIImage(named: "default_profile")
        
        // If the user's profile image is nil but the url is not,
        // fetch the profile pic
        if  (profileImg == nil && user.profileImgUrl != nil){
            user.fetchProfilePic(){ (image, imageBase64) in
                guard let image = image else {return}
                DispatchQueue.main.async {
                    self.profilePicImageView.image = image
                    self.user.profileImgBase64 = imageBase64
                    updateDefaults(data: ["profile_img": imageBase64 as Any])
                }
            }
        } 
        
        
        // Load the user's wallet balance
        self.user.wallet() { (json, code, _) in
            guard
                code == 200,
                let data = json?["data"] as? [String: Any],
                let activeBalance = data["active_balance"] as? Int
                else {return}
            self.accountBalanceLabel.text = String(format: "$%.2f", Double(activeBalance)/100)
            
        }
        

        // Set tab bar icon
        self.tabBarItem.selectedImage =
            UIImage(named: "profile color")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.title = ""
        
    }
    
}
