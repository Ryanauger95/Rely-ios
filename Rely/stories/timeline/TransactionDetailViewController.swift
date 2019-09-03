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
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelLabel: UILabel!
    
    var deal : Txn!
    var user : User!
    var peer : User!
    
    var userRole: DEAL_ROLE!
    var isOriginator: Bool!
    
    
    /*
     * Setup UI & Determine User Role
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Determine user role & status
        self.userRole = (self.user.userId == self.deal.payer.userId) ? .PAYER : .COLLECTOR
        self.isOriginator = (self.user.userId == self.deal.originator)

        // Configure UI
        self.styleDarkNav()
        self.title = "Details"
        profilePic.makeCircular()
        

        // Set Static Fields
        self.reserveLabel.text =
            String(format: "$%d", deal.reserve)
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
            
            self.cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
            if (self.isOriginator) {
                self.stateLbl.text = String(format: "Waiting for \(self.peer.firstName!) to accept")
                self.checkLabel.text = "Waiting"
                self.checkButton.imageView?.image = UIImage(named: "check-gray")
            } else {
                self.stateLbl.text = String(format: "Waiting for you to accept", self.peer.firstName!)
                self.checkLabel.text = "Accept"
                self.checkButton.imageView?.image = UIImage(named: "check-green")
                self.checkButton.addTarget(self, action: #selector(self.acceptRequest), for: .touchUpInside)
                
            }
            break
        case .PROGRESS:
            // If in progress, the collector can mark as complete
            if (self.deal.fundState != FUND_STATE.FEE_COMPLETE){
                self.stateLbl.text = String(format: "Waiting for funds to transfer into holding", self.peer.firstName!)
                self.checkButton.imageView?.image = UIImage(named: "check-gray")
                break;
            }
            self.cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
            if userRole == .COLLECTOR {
                self.stateLbl.text = String(format: "Waiting for you to mark the job complete", self.peer.firstName!)
                self.checkLabel.text = "Complete"
                self.checkButton.imageView?.image = UIImage(named: "check-green")
                self.checkButton.addTarget(self, action: #selector(self.markComplete), for: .touchUpInside)
            } else {
                self.stateLbl.text = String(format: "Waiting for \(self.peer.firstName!) to mark complete", self.peer.firstName!)
                self.checkLabel.text = "Approve"
                self.checkButton.imageView?.image = UIImage(named: "check-gray")
            }
            break
        case .REVIEW:
            // If under review, the payer can mark as approved
            if userRole == .PAYER {
                self.stateLbl.text = String(format: "Waiting for you to approve the job", self.peer.firstName!)
                self.checkLabel.text = "Approve"
                self.checkButton.imageView?.image = UIImage(named: "check-green")
                self.checkButton.addTarget(self, action: #selector(self.approveCompletion), for: .touchUpInside)
                self.cancelLabel.text = "Dispute"
                
            } else {
                self.stateLbl.text = String(format: "Waiting for \(self.peer.firstName!) to approve the job", self.peer.firstName!)
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
        performKYCIfNeeded(vc: self, user: self.user){ (didComplete) in
            if (didComplete == true) {
                self.deal.updateState(newState: DEAL_STATE.PROGRESS) {(json, code, error) in
                    if code == 200 {
                        self.alert(title: "Successfully accepted request!", message: "") { () in
                            self.navigationController?.popViewController(animated:true)
                        }
                    } else {
                        self.alert(title: "Failed to link account!", message: "") { () in
                            self.navigationController?.popViewController(animated:true)
                        }
                    }
                }

            } else {
                self.alert(title: "Failed to link account!", message: "", completion: nil)
            }
        }
    }
    

    @objc func markComplete() {
       NSLog("Marking Complete")
        performKYCIfNeeded(vc: self, user: self.user, completion: {(didComplete) in
            if (didComplete == true) {
                self.deal.updateState(newState: DEAL_STATE.REVIEW, completion: {(_, code, _) in
                    if (code == 200) {
                        self.alert(title: "Successfully marked job as complete!", message: "The job is now under review, and pending an acceptance by \(self.peer.firstName!)") { () in
                            self.navigationController?.popViewController(animated:true)
                        }
                    } else {
                       self.alert(title: "Unable to mark job as complete!", message: "", completion: nil)
                    }
                })
            } else {
                self.alert(title: "Failed to link account!", message: "", completion: nil)
            }
        })
    }
    
    @objc func approveCompletion() {
        NSLog("Approving Completion")
        self.deal.updateState(newState: DEAL_STATE.COMPLETE, completion: {(_, code, _) in
            if (code == 200) {
                self.alert(title: "Successfully marked job as approved!", message: "The job is complete, money will be available for transfer soon") { () in
                    self.navigationController?.popViewController(animated:true)
                }
            } else {
                self.alert(title: "Unable to mark job as approved", message: "", completion: nil)
            }
        })
    }
    
    @objc func cancelButtonPressed() {
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


