//
//  AmountViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class AmountViewController: UIViewController {
    
    @IBOutlet weak var continueBtnLbl: Button!
    @IBOutlet weak var totalAmountTxtFld: UITextField!
    @IBOutlet weak var reserveAmountTxtFld: UITextField!
    
    var requestBuilder : RequestBuilder!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Request"
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleDarkNav()
        self.totalAmountTxtFld.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        guard
            let total = Double(self.totalAmountTxtFld.text!),
            let reserve = (self.reserveAmountTxtFld.text == "") ? 0.0 : Double(self.reserveAmountTxtFld.text ?? "0") else {return}
        self.requestBuilder.totalAmount = total
        self.requestBuilder.reserveAmount = reserve
        self.requestBuilder.description = ""
        
        // Get the Fee
        self.requestBuilder.feeAmount = 0
        guard let request = Request(requestBuilder: requestBuilder) else {
            return
        }
        request.checkFee(){ (fee) in
            guard
                let fee = fee
                else {
                    self.alert(title: "Unable to calculate fee!", message: "", completion: nil)
                    return
            }
        self.requestBuilder.feeAmount = Double(fee)/100
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "SubmitRequestViewController") as! SubmitRequestViewController
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.requestBuilder = self.requestBuilder
        self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func reserveInfo(_ sender: Any) {
        let nextVC = ReserveViewController(nibName: "ReserveViewController", bundle: nil)
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
