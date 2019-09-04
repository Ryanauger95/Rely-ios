//
//  KYCViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/22/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit
import LinkKit

protocol RequestProtocol {
    func registerWallet(address1: String, address2: String, city: String, state: String, zip: String, ssn: String, dob: String) -> Void
}



class KYCViewController: UIViewController, PLKPlaidLinkViewDelegate, RequestProtocol  {

    @IBOutlet weak var linkBankView: View!
    @IBOutlet weak var linkBankCheckMark: UIImageView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var kycView: UIView!
    
    var user : User!
    var plaidToken : String? = nil
    var account : User.Account? = nil

    
    // Controls the flow
    // if KYC is required, then both bank and KYC are required
    // if KYC is false we just need the bank linked
    var kycRequired: Bool! = true
    var onDismissCb: KYCResultCb? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.hideKeyboardWhenTappedAround()
        
        //
        guard let user = User(defaults: true) else {return}
        self.user = user

        //
        let linkBankGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentPlaidLinkWithSharedConfiguration))
        self.linkBankView.isUserInteractionEnabled = true
        self.linkBankView.addGestureRecognizer(linkBankGesture)
        

    }
    
    //////////////////////////////////////////////////
    // Link the bank account
    //////////////////////////////////////////////////
    func changeBankLinkImageToComplete(){
        self.linkBankCheckMark.image = UIImage(named: "check-green")
    }
    func handleBankLinkComplete(account: User.Account, publicToken: String){
        self.changeBankLinkImageToComplete()
        
        // Prevent the user from attempting to link another bank account
        self.linkBankView.isUserInteractionEnabled = false
        
        // Save the public token
        self.plaidToken = publicToken
        self.account = account
        if (kycRequired == true){
            self.presentKYCView()
        } else {
            self.addActivity()
            self.linkBankAndDismiss()
        }
    }
    func linkBankAndDismiss(){
        guard
            let publicToken = self.plaidToken,
            let account = self.account
        else {
            bankLinkError()
            return
        }
        self.addActivity()
        user.linkBankToWallet(account: account, publicToken: publicToken, completion: { (json, code, error) in
            self.removeActivity()
            if (code == 200) {
                self.dismissAndRunCompletion(success: true)
            } else {
                self.bankLinkError()
            }
        })
    }
    func bankLinkError(){
        self.alert(title: "Error linking bank", message: "") {
            self.dismissAndRunCompletion(success: false)
        }
    }
    
    func dismissAndRunCompletion(success: Bool) {
        self.dismiss(animated: true) {
            guard let cb = self.onDismissCb else {return}
            cb(success)
        }
    }
    
    //////////////////////////////////////////////////
    // KYC/Bank Linkage view
    //////////////////////////////////////////////////
    func presentKYCView(){
        // Add the KYC View to the frame with an animation
        self.addActivity()
        let kycView = loadKycViewFromNib()
        kycView.frame = CGRect(x: 0, y: self.innerView.frame.height, width: self.innerView.frame.width, height: 490)
        self.innerView.frame = CGRect(x: self.innerView.frame.origin.x, y: self.innerView.frame.origin.y, width: self.innerView.frame.width, height: self.innerView.frame.height + 500)
//        self.kycView.removeFromSuperview()
        self.innerView.addSubview(kycView)
        self.removeActivity()
    }
    
    func loadKycViewFromNib() -> UIView {
        let view = UINib(nibName: "KYC", bundle: .main).instantiate(withOwner: nil, options: nil).first as! KYCView
        view.requestDelegate = self
        return view
    }
    
    

    
    //////////////////////////////////////////////////
    /// Delegate functions
    //////////////////////////////////////////////////
    func registerWallet(address1: String, address2: String, city: String, state: String, zip: String, ssn: String, dob: String) {
        self.addActivity()
        user.registerWallet(address1: address1, address2: address2, city: city, state: state, zip: zip, ssn: ssn, dob: dob) { (json, code, error) in
            self.removeActivity()
            guard code == 200 else {
                self.bankLinkError()
                return
            }
            self.linkBankAndDismiss()
        }
    }
    

    //////////////////////////////////////////////////
    //  PLAID Section & Callbacks
    //////////////////////////////////////////////////
    @objc func presentPlaidLinkWithSharedConfiguration() {
        let linkViewController = PLKPlaidLinkViewController(delegate: self)

        linkViewController.modalTransitionStyle = .crossDissolve
        linkViewController.modalPresentationStyle = .overCurrentContext
        present(linkViewController, animated: true)
    }
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        guard
            let institution = metadata?["institution"] as? [String:Any],
            let institutionName = institution["name"] as? String,
            let accountObj = metadata?["account"] as? [String:Any],
            let mask = accountObj["mask"] as? String,
            let typeName = accountObj["name"] as? String
        else {
                return
        }
        let account = User.Account(institution: institutionName, mask: mask, type: typeName)
        dismiss(animated: true){
            DispatchQueue.main.async {
                self.handleBankLinkComplete(account: account, publicToken: publicToken)
            }
        }
    }
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
            }
        }
    }
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
        NSLog("Link event: \(event)\nmetadata: \(metadata ?? [:])")
    }
    
    
    
    // Simple X button to dismiss the modal VC
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
