//
//  MobileEntryViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/28/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import FlagPhoneNumber

extension MobileVerificationViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        numberValid = isValid
        if isValid {
            phoneNumber = textField.getFormattedPhoneNumber(format: .E164)
            print("Number : ", phoneNumber as Any)
        } else {
            print("Validity : ", numberValid as Any)
        }
    }
}

class MobileVerificationViewController: UIViewController {
    
    @IBOutlet weak var contactNumberTxt: UITextField!
    @IBOutlet weak var countryCodeTxt: UITextField!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var list = ["1", "2", "3"]
    var verification = NSNumber()
    
    // Phone number field
    var phoneNumberTextField: FPNTextField!
    var numberValid: Bool! = false
    var phoneNumber: String! = ""
    
    var user : User!

    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleClearNav()
        descLbl.adjustsFontSizeToFitWidth = true
        changeBehaviours()
        
        // Initialize the phone number field
        phoneNumberTextField = FPNTextField(frame: CGRect(x: 95, y: 300, width: view.bounds.width - 70, height: 50))
        phoneNumberTextField.borderStyle = .roundedRect
        
        // Comment this line to not have access to the country list
        phoneNumberTextField.parentViewController = self
        phoneNumberTextField.delegate = self
        
        // Custom the size/edgeInsets of the flag button
        phoneNumberTextField.flagSize = CGSize(width: 35, height: 35)
        phoneNumberTextField.flagButtonEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        view.addSubview(phoneNumberTextField)
        
        phoneNumberTextField.center = view.center
        
        // Hide Keyboard when pressed outside
        self.hideKeyboardWhenTappedAround()
        
        user = User(defaults: true)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {

        if numberValid {
            user.phoneNumberUpdate(
            phone: phoneNumber!){
            (json, code, error) in
                guard
                    code == 200
                    else { return }
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CodeEntryViewController") as! CodeEntryViewController
                nextVC.mobileNumber = self.phoneNumber
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
    func changeBehaviours(){
        //countryCodeTxt.setBottomBorderIntoTextOfMobileVerification()
        //contactNumberTxt.setBottomBorderIntoTextOfMobileVerification()
        
        nextBtn.layer.cornerRadius = 30
        descLbl.autoresizesSubviews = true
        nextBtn.applyProfileChangeUINextGreenButtonDesign()
    }
    @IBAction func mobileBackAction(_ sender: Any) {
        
    }
    @IBAction func mobNumberChange(_ sender: Any) {
        let f1 = contactNumberTxt.text
        let num = Int(f1!)
        
        if num == nil {
            contactNumberTxt.deleteBackward()
            return
        }
        if (f1?.count)! > 10 {
            contactNumberTxt.deleteBackward()
            return
        }
    }
    @IBAction func countryCodeChange(_ sender: Any) {
        let f1 = countryCodeTxt.text
        let num = Int(f1!)
        
        if num == nil {
            countryCodeTxt.deleteBackward()
            return
        }
        if (f1?.count)! > 3 {
            countryCodeTxt.deleteBackward()
            return
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
    }
    
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //
    //        self.countryCodeTxt.text = self.list[row]
    //        self.dropDown.isHidden = true
    //    }
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //
    //        if textField == self.countryCodeTxt {
    //            self.dropDown.isHidden = false
    //            //if you don't want the users to se the keyboard type:
    //
    //            textField.endEditing(true)
    //        }
    //    }
}

extension UITextField{
    func setBottomBorderIntoTextOfMobileVerification(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 0.0
    }
}

extension UIButton{
    func applyProfileChangeUINextGreenButtonDesign(){
        
        self.layer.shadowColor = UIColor.black.cgColor
        //        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 3.5)
    }
}

