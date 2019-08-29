//
//  DisputeNoHistoryViewController.swift
//  Rely
//
//  Created by kavii on 2/11/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import UIKit


class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var reserveLabel: UILabel!
    @IBOutlet weak var daysRemainingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var deal : Txn!
    var user : User!
    var peer : User!
    
    var userRole: DEAL_ROLE!
    
    
    /*
     * Setup UI & Determine User Role
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Determine user role & status
        self.userRole = (self.user.userId == self.deal.payer.userId) ? .PAYER : .COLLECTOR

        // Configure UI
        self.styleDarkNav()
        self.title = "Details"
        profilePic.makeCircular()
        

        // Set Static Fields
        self.reserveLabel.text =
            String(format: "$%d", deal.reserve)
//        self.daysRemainingLabel.text = String(format: "%d days left", daysRemaining(dateStart: Date(), dateEnd: deal.endDate)!)
//        self.daysRemainingLabel.text = String(format: "%d days left", deal.period)
        self.daysRemainingLabel.text = "STATE"
        self.amountLabel.text = String(format: "$%d", deal.amount)
        self.nameLabel.text = self.peer.firstName! + " " + self.peer.lastName!
        self.profilePic.image = self.peer.profileImgBase64?.toUIImage()
        self.descriptionTextView.text = deal.description

        
        // Based on the status of the deal, the user can perform
        // certain operations
        switch (self.deal.dealState) {
            // Not sure what to do here
        case .DISPUTE:
            break
        case .PENDING:
            // If pending, check who initiated.
            // If the payer initiated, then the collector will be accepting, so
            //      we just change the status of the request and notify parties
            // If the collector initiated, then the payer will be accepting
            //      the job, so we must perform KYC as well
            if self.deal.originator == self.user.userId {
                self.checkLabel.text = "Waiting"
                self.checkButton.imageView?.image = UIImage(named: "check-gray")
            } else {
                self.checkLabel.text = "Accept"
                self.checkButton.imageView?.image = UIImage(named: "check-green")
                if self.userRole == .PAYER {
                self.checkButton.addTarget(self, action: #selector(self.acceptRequest), for: .touchUpInside)
                } else {
                    self.checkButton.addTarget(self, action: #selector(self.acceptRequest), for: .touchUpInside)
                }
            }
            break
        case .PROGRESS:
            // If in progress, the collector can mark as complete
            if userRole == .COLLECTOR {
                self.checkLabel.text = "Complete"
                self.checkButton.imageView?.image = UIImage(named: "check-green")
                self.checkButton.addTarget(self, action: #selector(self.markComplete), for: .touchUpInside)
            } else {
                self.checkLabel.text = "Approve"
                self.checkButton.imageView?.image = UIImage(named: "check-gray")
            }
            break
        case .REVIEW:
            // If under review, the payer can mark as approved
            if userRole == .PAYER {
                self.checkLabel.text = "Approve"
                self.checkButton.imageView?.image = UIImage(named: "check-green")
            } else {
                self.checkLabel.text = "Complete"
                self.checkButton.imageView?.image = UIImage(named: "check-gray")
            }
            break
        // Else, we shouldn't be here
        case .TIMEOUT:
            fallthrough
        case .CANCELLED:
            fallthrough
        case .COMPLETE:
            fallthrough
        @unknown default:
            break
        }
        
    }
    
    @objc func acceptRequest() {
       NSLog("Accepting Request!")
        if self.userRole == .PAYER {
            // 1. GET to see if I have an account
            self.user.wallet(completion: {(json, code, err) in
                guard let code = code else { return }
                if code == 200 {
                    // PUT Mark the deal as in progress
                } else {
                    // Register for KYC. At end of KYC, PUT mark the deal
                    // as in progress
                    self.presentKYC()
                }
                print("Retreived Wallet")
            })
        } else {
            // PUT Mark the deal as in progress
        }
    }
    
    func presentKYC() {
        let storyboard = UIStoryboard(name: "KYC", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "KYCViewController")
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true, completion: nil)
    }

    @objc func markComplete() {
       NSLog("Marking Complete")
    }
    
    @objc func approveCompletion() {
       NSLog("Approving Completion")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CancelDealViewController") as! CancelDealViewController
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.user = self.user
        nextVC.userRole = self.userRole
        nextVC.deal = self.deal
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func contactButtonPressed(_ sender: Any) {
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        contactVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        contactVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        contactVC.user = peer
        self.present(contactVC, animated: true, completion: nil)
    }
    
    @IBAction func reserveInfo(_ sender: Any) {
        let nextVC = ReserveViewController(nibName: "ReserveViewController", bundle: nil)
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
}


