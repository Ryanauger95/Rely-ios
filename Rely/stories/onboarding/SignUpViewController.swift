//
//  SignUpViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/28/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{


    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var email: UITextField!
    

    
    
    let checkbox = Checkbox(frame: CGRect(x: 50, y: 50, width: 25, height: 25))

    var check = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI
        self.title = "Sign Up"
        self.styleClearNav()
        self.continueBtn.blueStyle()
        self.firstName.inputStyle()
        self.lastName.inputStyle()
        self.password.inputStyle()
        self.retypePassword.inputStyle()
        self.email.inputStyle()

        // Hide Keyboard when pressed outside
        self.hideKeyboardWhenTappedAround()
        
        //
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.password.delegate = self
        self.retypePassword.delegate = self
        self.email.delegate = self
        
        
        // TODO: MAJOR HACK FOR TESTING!!
        self.firstName.text = "TestUser"
        self.lastName.text = "TestUser"
        self.email.text = "test14@gmail.com"
        self.password.text = "123"
        self.retypePassword.text = "123"
        
        
    }

    @IBAction func agreeToTermsAction(_ sender: DLRadioButton) {
        if check {
            sender.isSelected = false
            check = false
        }else{
            check = true
            sender.isSelected = true
        }
    }
    

    
    @IBAction func continueBtnAction(_ sender: Any) {
        guard
            let fName = self.firstName.text as String?,
            let lName = self.lastName.text as String?,
            let email = self.email.text as String?,
            let password = self.password.text as String?,
            let retypePassword = self.retypePassword.text as String?
        else { return }
        

        if (password != retypePassword) {
            self.retypePassword.redBorder()
            self.password.redBorder()
            self.alert(title: "Passwords to not match!", message: "", completion: nil)
            return
        }
        
        // take SHA256 of the password to use as the password
        let token = passwordToToken(password: password)
        
        if !Validations().validateEmail(email: email) {
            self.email.redBorder()
            self.alert(title: "Email invalid!", message: "", completion: nil)
            return
        }

        if !check {
            let alertController = UIAlertController(title: "Warnings!", message: "Please Accept Terms and Conditions", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }

        let user = User(
            userId: -1,
            firstName: fName,
            lastName:lName,
            email:email,
            token:token
        )
        self.addActivity()
        user.signup(completion: {(loggedUser,err) in
            self.removeActivity()
            guard let loggedUser = loggedUser else {
                var message = ""
                if (err == SIGNUP_ERROR.DUPLICATE) {
                    message = "Email address already in use!"
                } else {
                    message = "Unknown error"
                }
                self.alert(title: "Failed to sign up", message: message, completion: nil)
                return
            }
            loggedUser.saveToDefaults()

            // segue
            let alertController = UIAlertController(title: "Successful!", message: "Successfull", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let storyboard = UIStoryboard(name: "Verification", bundle: nil)
                let nextVC = storyboard.instantiateViewController(withIdentifier: "MobileVerificationViewController")
                let navigationController = UINavigationController(rootViewController: nextVC)
                self.present(navigationController, animated: true, completion: nil)

            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)


        })

    }

    func removeAllBorders(){
        self.firstName.layer.borderWidth = 0
        self.lastName.layer.borderWidth = 0
        self.email.layer.borderWidth = 0
        self.password.layer.borderWidth = 0
        self.retypePassword.layer.borderWidth = 0
    }
    
    // Text Field Functions to automatically move between them
    func nextTextField(textField: UITextField) {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.nextTextField(textField: textField)
        // Do not add a line break
        return false
    }
    var rangeReplacedWithSpaceAt: Date?

    var rangeReplacedWithSpace: NSRange?

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // To detect AutoFill, look for two quick replacements. The first replaces a range with a single space.
        // The next replaces the same range with the autofilled content.
        if string == " " {
            self.rangeReplacedWithSpace = range
            self.rangeReplacedWithSpaceAt = Date()
        } else {
            if rangeReplacedWithSpace == range,
                let rangeReplacedWithSpaceAt = self.rangeReplacedWithSpaceAt,
                Date().timeIntervalSince(rangeReplacedWithSpaceAt) < 0.1 {

                DispatchQueue.main.async {
                    // Whatever you use to move forward.
                    self.nextTextField(textField: textField)
                }
            }
            self.rangeReplacedWithSpace = nil
            self.rangeReplacedWithSpaceAt = nil
        }
       return true
    }
}

extension UITextField {
    func redBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
    }
}
