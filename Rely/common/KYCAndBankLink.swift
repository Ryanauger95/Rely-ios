//
//  KYCAndBankLink.swift
//  Rely
//
//  Created by Ryan Auger on 9/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

typealias KYCResultCb = (Bool) -> Void


func performKYCIfNeeded(vc: UIViewController, user: User, additionalBankLink: Bool? = false, completion: @escaping KYCResultCb) {
    // If the user is sending the money, then
    // 1. Check to see if user is registered with SILA
    user.getWallet(){(json, code, error) in
        if code == 200 {
            guard
                let data = json?["data"] as? [String:Any],
                let bankLinked = data["bank_linked"] as? Bool
                else {
                    completion(false)
                    return
            }
            if (bankLinked == true) {
                presentKYC(vc: vc, kycRequired: false, completion: completion)
            } else {
                presentKYC(vc: vc, kycRequired: false, completion: completion)
                // TODO: once complete, run callback
            }
        } else if code == 404 {
            // If not registered, present the KYC view
            presentKYC(vc: vc, kycRequired: true, completion: completion)
            // TODO: once complete, submit txn
        } else {
            // Unknown Failure
            completion(false)
        }
    }
}

func presentKYC(vc: UIViewController, kycRequired: Bool, completion: @escaping KYCResultCb) {
    let storyboard = UIStoryboard(name: "KYC", bundle: nil)
    let nextVC = storyboard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
    nextVC.modalTransitionStyle = .crossDissolve
    nextVC.modalPresentationStyle = .overCurrentContext
    nextVC.kycRequired = kycRequired
    nextVC.onDismissCb = completion
    vc.present(nextVC, animated: true, completion: nil)
}
