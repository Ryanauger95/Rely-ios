//
//  SubmitRequestViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class SubmitRequestViewController: UIViewController, UIPopoverPresentationControllerDelegate {


    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var amountTxt: UILabel!
    @IBOutlet weak var reserveTxt: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var feeLabel: UILabel!
    
    var requestBuilder : RequestBuilder!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let amount = self.requestBuilder.totalAmount,
            let reserve = self.requestBuilder.reserveAmount,
            let payerFirstName = requestBuilder.payer?.firstName,
            let payerLastName = requestBuilder.payer?.lastName,
            let fee = self.requestBuilder.feeAmount,
            let _user = User(defaults: true)
            else { return }
        self.user = _user

        // Setup UI
        self.title = "Submit"
        self.styleDarkNav()
        self.descriptionTextView.addCorners()
        let payerName = payerFirstName + " " + payerLastName
        self.userNameBtn.setTitle(payerName, for: .normal)
        self.amountTxt.text = "$\(amount)"
        self.reserveTxt.text = "$\(reserve)"
        self.feeLabel.text = "$\(fee)"
        
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    // If we send, then we are the payer
    @IBAction func send(_ sender: Any) {
        if (requestBuilder.collector?.userId == user.userId){
            requestBuilder.collector = requestBuilder.payer
            requestBuilder.payer = user
        }
        guard let request = Request(requestBuilder: requestBuilder) else {
            return
        }
        self.alert(title: "Confirm", message: "You are creating a transaction to pay $\(request.totalAmount!) to \(request.collector.firstName!). A $\(request.feeAmount!) fee will be added to the transaction. We will charge $\(request.payerTotal!) once the job is accepted, and place $\(request.totalAmount!) into holding ", cancelEnabled: true, completion: {
            self.checkWalletAndSubmitTxn()
        })
        checkWalletAndSubmitTxn()
    }
    
    // If we request, then we are the collector
    @IBAction func request(_ sender: Any) {
        if (requestBuilder.payer?.userId == user.userId){
            requestBuilder.payer = requestBuilder.collector
            requestBuilder.collector = user
        }
        guard let request = Request(requestBuilder: requestBuilder) else {
            return
        }
        self.alert(title: "Confirm", message: "You are requesting $\(request.payerTotal!) from \(request.payer.firstName!). A $\(request.feeAmount!) fee will be deducted once the job is accepted. Upon approval of the job, you will receive $\(request.collectorTotal!)", cancelEnabled: true, completion: {
        self.checkWalletAndSubmitTxn()
        })
    }
    
    
    func checkWalletAndSubmitTxn(){
        requestBuilder.description = self.descriptionTextView.text ?? ""
        guard let request = Request(requestBuilder: requestBuilder) else {
            return
        }
        
        // If the user is sending the money, then
        // 1. Check to see if user is registered with SILA
        user.getWallet(){(json, code, error) in
            if code == 200 {
                guard
                    let data = json?["data"] as? [String:Any],
                    let bankLinked = data["bank_linked"] as? Bool
                    else {
                        self.alert(title: "Error", message: "Error communicating with server!", completion: nil)
                        return
                }
                if (bankLinked == true) {
                    self.submitTxn(request: request)
                } else {
                    self.presentKYC(kycRequired: false)
                }
                
                
                // If registered, submit the Txn, present KYC screen
            } else if code == 404 {
                // If not registered, present the KYC view
                self.presentKYC(kycRequired: true)
                // TODO: once complete, submit txn
            } else {
                self.alert(title: "Error", message: "Retry Later", completion: nil)
            }
        }
    }
    func presentKYC(kycRequired: Bool) {
        let storyboard = UIStoryboard(name: "KYC", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.kycRequired = kycRequired
        self.present(nextVC, animated: true, completion: nil)
    }
    
    

    

    func submitTxn(request: Request) {
        request.submit(){ (json, code, error) in
            if (code == 200){
                self.alert(title: "Submitted Job",
                           message: "Successfully submitted job! We will notify the other party",
                           completion: {() in
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                self.present(nextVC, animated: true, completion: nil)
                })
            } else {
                self.alert(title: "Error!", message: "Error submitting transaction!", completion: nil)
            }
        }
    }

}

