//
//  KYCView.swift
//  reli
//
//  Created by Ryan Auger on 8/28/19.
//  Copyright © 2019        . All rights reserved.
//

import UIKit

class KYCView: UIView {
    @IBOutlet weak var addressOneTextField: UITextField!
    @IBOutlet weak var addressTwoTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var ssnTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    var requestDelegate: RequestProtocol?
    
    override func awakeFromNib() {
        self.completeButton.greenStyle()
        self.addressOneTextField.becomeFirstResponder()
        
        #if targetEnvironment(simulator)
        addressOneTextField.text = "4517 Country Lane"
        addressTwoTextField.text = ""
        cityTextField.text = "Charlotte"
        stateTextField.text = "NC"
        zipcodeTextField.text = "28270"
        ssnTextField.text = "123452222"
        #endif
    }
    @IBAction func completeRequest(_ sender: Any) {
        if (requestDelegate == nil){
            return
        }
        self.completeButton.isEnabled = false
        guard
            let address1 = addressOneTextField.text,
            let address2 = addressTwoTextField.text,
            let city = cityTextField.text,
            let state = stateTextField.text,
            let zipcode = zipcodeTextField.text,
            let ssn = ssnTextField.text else {return}
            
        requestDelegate?.registerWallet(address1: address1, address2: address2, city: city, state: state, zip: zipcode, ssn: ssn)
    }
    
}
