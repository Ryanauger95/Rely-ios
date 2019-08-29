//
//  SignInViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/28/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var dataArray = ["alex","james","nicole"]
    var val = 0
    var veified : NSNull? = nil
    var token : String = ""
    var userID : NSNumber = 0.0
    var user: User?
    var isFirstLogin = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign In"
        self.styleClearNav()
        
        // Style buttons
        self.getStartedBtn.lightGreenStyle()
        self.continueBtn.greenStyle()

        // Hide Keyboard when pressed outside
        self.hideKeyboardWhenTappedAround()
        
        user = User(defaults: true)
        if (user == nil){
            return
        }
        
        self.emailField.text = user?.email
        self.passwordField.text = user?.token
        continueBtnAction(self)
    }
    
    @IBAction func continueBtnAction(_ sender: Any){
        
        guard
            let email = emailField.text,
            let password = passwordField.text
            else {return}
        
        let fine = Validations().validateEmail(email: email)
        if !fine {
            emailField.layer.borderWidth = 1
            emailField.layer.borderColor = UIColor.red.cgColor
        }else{
            emailField.layer.borderWidth = 0
        }
        
        var token = password
        
        // We only tokenize the password if the user has entered a
        // password, and it wasn't an autofilled token by us
        if (user?.token != password){
            isFirstLogin = true
            token = passwordToToken(password: password)
        }
        
        // Try login
        let user = User(userId: -1, email: email, token: token)
        self.addActivity()
        user.login() { (loggedUser, err) in
            self.removeActivity()
            guard let newUser = loggedUser else {
                var message = ""
                if (err == LOGIN_ERROR.INVALID_USERPASS) {
                    message = "Invalid email/password combo"
                } else {
                    message = "Unknown"
                }
                self.alert(title: "Error", message: message, completion: nil)
                
                return
            }
            if (self.isFirstLogin) {
                newUser.saveToDefaults()
                newUser.fetchProfilePic(completion: {(image, imageBase64) in
                    updateDefaults(data: ["profile_img": imageBase64 as Any])
                })
            }

            if newUser.phone_validated != true {
                let storyboard = UIStoryboard(name: "Verification", bundle: nil)
                let nextVC = storyboard.instantiateViewController(withIdentifier: "MobileVerificationViewController")
                let navigationController = UINavigationController(rootViewController: nextVC)
                self.present(navigationController, animated: true, completion: nil)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar = (storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! UITabBarController)
            self.present(tabbar, animated: true, completion: nil)
            
        }
    }

    
}
