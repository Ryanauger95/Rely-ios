//
//  BankLinkViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/12/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit
import LinkKit


class BankLinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var linkAccountView: View!
    @IBOutlet weak var tableView: UITableView!
    
    
    var accounts : [User.Account] = []
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
        user.getAccounts(){ (accounts) in
            guard
                let accounts = accounts else {return}
            self.accounts = accounts
            self.tableView.reloadData()
        }
    }
    @objc func linkBank() {
        performKYCIfNeeded(vc: self, user: self.user, additionalBankLink: true) {(result) in
            if result == true {
            
            } else {
            
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankTableViewCell") as! BankTableViewCell
        let account = accounts[indexPath.row]
        
        cell.accountName.text = account.name
//        cell.institutionName.text = account.institution

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 34
    }
    
}
