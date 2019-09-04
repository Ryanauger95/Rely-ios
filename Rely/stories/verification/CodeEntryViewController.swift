//
//  CodeEntryViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/28/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class CodeEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var code1Txt: UITextField!
    @IBOutlet weak var code2Txt: UITextField!
    @IBOutlet weak var code3Txt: UITextField!
    @IBOutlet weak var code4Txt: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var time = 250
    var timer = Timer()
    var mobileNumber : String!
    var user: User!
    
    @IBOutlet weak var counterLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        self.styleClearNav()
        self.nextBtn.layer.cornerRadius = self.nextBtn.layer.frame.height/2
        
        //
        startCountdown()
        nextBtn.isEnabled = false
        user = User(defaults: true)
        
        self.hideKeyboardWhenTappedAround()
        
        //
        code1Txt.becomeFirstResponder()
        
        //
        code1Txt.delegate = self
        code2Txt.delegate = self
        code3Txt.delegate = self
        code4Txt.delegate = self
        
        code1Txt.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        code2Txt.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        code3Txt.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        code4Txt.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        guard let text = textField.text else {return}
        if text.count >= 1{
            switch textField{
            case code1Txt:
                code2Txt.becomeFirstResponder()
            case code2Txt:
                code3Txt.becomeFirstResponder()
            case code3Txt:
                code4Txt.becomeFirstResponder()
            case code4Txt:
                code4Txt.resignFirstResponder()
                self.enableBtn()
            default:
                break
            }
        }
    }
    
    func startCountdown(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.countdown)), userInfo: nil, repeats: true)
    }
    @objc func countdown(){
        time -= 1
        counterLbl.text = String(time)+" s"
        
        if time == 0 {
            time += 1
        }
    }
    @IBAction func reSendAction(_ sender: Any) {
        counterLbl.text = "250"+" s"
        time = 250
    }
    func enableBtn(){
        if (code1Txt.text == "" || code2Txt.text == "" || code3Txt.text == "" || code4Txt.text == "" ) {
            nextBtn.isEnabled = false
            let color = UIColor(red: 219, green: 223, blue: 230)
            nextBtn.backgroundColor = color
        }else{
            nextBtn.isEnabled = true
            let color = UIColor(red: 91, green: 218, blue: 49)
            nextBtn.backgroundColor = color
        }
    }
    @IBAction func continueAction(_ sender: Any) {
        let code1 = code1Txt.text
        let code2 = code2Txt.text
        let code3 = code3Txt.text
        let code4 = code4Txt.text
        
        let code = code1! + code2! + code3! + code4!
        
        user.phoneNumberConfirmOTC(code: code){ (json, code, error) in
            guard
                code == 200
                else {return}
            
            self.user.phone = self.mobileNumber
            

            let alertController = UIAlertController(title: "Successfully!", message: "Mobile Number Verified", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            { UIAlertAction in
               // segue to main navigation controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbar = (storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! UITabBarController)
                self.present(tabbar, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

