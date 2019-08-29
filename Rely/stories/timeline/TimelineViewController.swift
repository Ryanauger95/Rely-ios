//
//  TimelineViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class TimelineViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBarTxt: UITextField!
    @IBOutlet weak var table: UITableView!

    var search = Search()
    var user : User!
    
    var requestDealList : [Txn] = []
    var searchConnected : Bool = false
    var hasAppearedOnce = false
    
    override func viewDidAppear(_ animated: Bool) {
        guard let user = User(defaults: true) else {return}
        if user.profileImgUrl == nil && !self.hasAppearedOnce{
            let nextStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let nextVC = nextStoryboard.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
            nextVC.modalPresentationStyle = .overCurrentContext
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
        }
        self.hasAppearedOnce = true
        self.addActivity()
        loadData(completion: {() in
            DispatchQueue.main.async {
                self.removeActivity()
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        
        // Set tab bar icon
        self.tabBarItem.selectedImage =
            UIImage(named: "handshake color")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "handshake")?.withRenderingMode(.alwaysOriginal)

        // Fetch user data
        user = User(defaults: true)

        // UI
        self.styleDarkNav()
        self.hideKeyboardWhenTappedAround()
        self.table.separatorStyle = .none

        

        self.setupSearchBar()
        self.setupSearch()
    }
    
    
    //////////////////////////////////////////////////
    // UI Setup
    //////////////////////////////////////////////////
    func setupSearchBar() {
        let color = UIColor(rgb: 0xADB3C0)
        searchBarTxt.attributedPlaceholder = NSAttributedString(string: "Name, Email, or Phone", attributes: [NSAttributedString.Key.foregroundColor: color])
        searchBarTxt.backgroundColor = UIColor.white
        searchBarTxt.layer.cornerRadius = searchBarTxt.frame.height/2
        searchBarTxt.setPadding(left: 20, right: 0)
    }
    
    //////////////////////////////////////////////////
    // Load data from the backend
    //////////////////////////////////////////////////
    // Load Data w/ Search Bar
    func setupSearch() {
        self.search.setConnectCallback(callback: self.setSearchConnected)
        self.search.setDealSearchCallback(callback: self.loadTableDealSearchResult)
        self.search.connect()
    }
    
    func setSearchConnected(data: [Any], error: SocketAckEmitter) -> Void {
        NSLog("Search bar connected")
        self.searchConnected = true
    }
    @IBAction func searchBarDidChange(_ sender: Any) {
        if !searchConnected {
            return
        }
        self.search.start_deal_search(userID: self.user!.userId, term: self.searchBarTxt.text ?? "")
    }

    func loadTableDealSearchResult(data: [Any], error: SocketAckEmitter) -> () {
        guard let json = data as?  [String: Any],
            let userList = json["deals"] as? [[String: Any]] else {
            if self.searchBarTxt.text == "" {
                self.loadData(completion: nil)
            }
            return
        }

        self.requestDealList.removeAll()
        for data in userList {
            guard let deal = Txn(data: data) else { continue }
            self.requestDealList.append(deal)
        }
        self.table.reloadData()
    }
    
    //Load Directly from API
    func loadData(completion: (()->Void)?){
        user.getActiveTxns(){ (json, code, error) in
            guard
                code == 200,
                let userList = json?["data"] as? [[String: Any]]
                else {
                    completion?()
                    return
            }
            self.requestDealList.removeAll()
            for data in userList {
                guard let deal = Txn(data: data) else {continue}
                self.requestDealList.append(deal)
            }
            self.table.reloadData()
            completion?()
        }
    }
    //////////////////////////////////////////////////
    // TableView setup
    //////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        table = nil
        table = tableView
        return requestDealList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4",for : indexPath) as! TimelineTableViewCell
        cell.selectionStyle = .none
        
        let deal = requestDealList[indexPath.row]
        let userRole: DEAL_ROLE = (user.userId == deal.payer.userId) ? .PAYER : .COLLECTOR
        let dealPeer = (user.userId == deal.payer.userId) ? deal.collector : deal.payer
        guard
            let firstName = dealPeer.firstName,
            let lastName = dealPeer.lastName
            else {return cell}
        
        
        // Fill all of the fields
        cell.timelineNameLbl.text = "\(firstName) \(lastName)"
        cell.timelineImg.image = UIImage(named: "default_profile")
        cell.timelineDescription.text = "Description: " + ((deal.description == "") ? "No description" : deal.description)
        cell.timelineAmountLbl.text = ((userRole == .PAYER) ? "-" : "+")  + String(format: "$%d", deal.amount)
        cell.timelineDayLbl.text = deal.dealState.rawValue

        if (deal.dealState == .DISPUTE) {
            cell.timelineStatusIcon.image =  UIImage(named: "alert")
        } else {
            cell.timelineStatusIcon.isHidden = true
        }

        // Fetch the profile picture
        dealPeer.profileImgBase64 = UIImage(named: "default_profile")?.toBase64()
        cell.timelineImg.image = UIImage(named: "default_profile")
        dealPeer.fetchProfilePic(completion: {(image, imageBase64) in
            DispatchQueue.main.async {
                dealPeer.profileImgBase64 = imageBase64
                cell.timelineImg.image = image
            }
        })
        
       return (cell)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deal = requestDealList[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailViewController") as! TransactionDetailViewController
        nextVC.user = self.user
        nextVC.deal = deal
        nextVC.peer = (user.userId == deal.payer.userId) ? deal.collector : deal.payer

        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
