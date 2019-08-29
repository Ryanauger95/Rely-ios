//
//  BankLinkViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/12/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit
import LinkKit

struct account_t {
    let name: String
    let mask: String
}

class BankLinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PLKPlaidLinkViewDelegate {

    @IBOutlet weak var linkAccountView: View!
    @IBOutlet weak var tableView: UITableView!
    
    
    var accounts : [account_t] = []
    var enterLinkImmediately = false
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleDarkNav()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addTableHeader(header: "Linked Accounts")
        self.tableView.tableHeaderView?.backgroundColor = UIColor.clear
        
        // Add functionality for all of the options
        let linkbankGesture = UITapGestureRecognizer(target: self, action: #selector(self.linkBank))
        self.linkAccountView.isUserInteractionEnabled = true
        self.linkAccountView.addGestureRecognizer(linkbankGesture)
        
        if enterLinkImmediately {
            self.linkBank()
        }
        
        self.user = User(defaults: true)
        BankApi().getAll(id: user.userId, completion: {(json, code, error) in
            guard
                let json = json,
                json["status"] as? String == "success",
                let accounts = json["accounts"] as? [[String: String]]
                else {return}
            for account in accounts {
                guard
                    let name = account["name"],
                    let mask = account["mask"]
                    else {return}
                self.accounts.append(account_t(name: name, mask: mask))
                self.tableView.reloadData()
            }
            
        })

    }
    @objc func linkBank() {
       self.presentPlaidLinkWithSharedConfiguration()
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            guard
                let metadata = metadata ,
                let accounts = metadata["accounts"] as? [Any]
            else {return}
            // Link the plaid public token to the account
            BankApi().linkPlaid(id: self.user.userId, publicToken: publicToken, completion: { (json, code, error) in
                
                // If we successfully link, we send the public token to
                // our banking partner
                guard
                    let json = json,
                    json["status"] as? String == "success"
                else {return}
                
                // Add each account to an array
                for iter in accounts {
                    guard
                        let account = iter as? [String:Any],
                        let name = account["name"] as? String,
                        let mask = account["mask"] as? String,
                        let id = account["id"] as? String,
                        let type = account["type"] as? String,
                        let subtype = account["subtype"] as? String
                        else {continue}
                    let bank = BankModel(id: id, name: name, mask: mask, type: type, subtype: subtype)
                    
                    // Link the account in the database
                    BankApi().linkBank(id: self.user.userId, bank: bank, completion: {(json, code, error) in
                        guard
                            let json = json,
                            json["status"] as? String == "success"
                            else {
                                self.basicAlert(type: .FAILURE, completion: nil)
                                return
                        }
                        let _account = account_t(name: name, mask: "****-****-****-" + mask)
                        self.accounts.append(_account)
                        self.tableView.reloadData()
                    })
                }
                
                NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata)")
            })
            
        }
    }
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
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
    
    
    // MARK: Plaid Link setup with shared configuration from Info.plist
    func presentPlaidLinkWithSharedConfiguration() {
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet
        }
        present(linkViewController, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankTableViewCell") as! BankTableViewCell
        let account = accounts[indexPath.row]
        
        cell.accountName.text = account.name
        cell.accountMask.text = account.mask
//        cell.institutionName.text = account.institution

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 82
    }
    
}
