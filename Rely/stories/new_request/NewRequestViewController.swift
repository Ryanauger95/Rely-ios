//
//  NewRequestViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/30/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class NewRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // Outlets
    @IBOutlet weak var searchBarTxt: UITextField!
    @IBOutlet weak var table: UITableView!
    
    var requestBuilderProfileList : [User] = []
    
    var processingIndicator: UIActivityIndicatorView!
    
    var requestBuilder: RequestBuilder!
    var user : User!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "New Request"
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        
        //
        user = User(defaults: true)
        requestBuilder = RequestBuilder(originator: user.userId)
        requestBuilder.collector = user
        
        
        // Setup UI
        self.styleDarkNav()
        self.table.addTableHeader(header: "Top People")
        self.setupSearchBar()

        // Start the activity indicator
        addActivityIndicator()
        processingIndicator.hidesWhenStopped = true

        // Get stored list of users
        loadData()
        
        // Set tab bar icon
        self.tabBarItem.selectedImage =
            UIImage(named: "new rquest btn")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "new rquest btn")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.title = ""
    }
    func addActivityIndicator() {
        self.processingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.processingIndicator.style = UIActivityIndicatorView.Style.gray
        self.processingIndicator.center = self.view.center
        self.view.addSubview(processingIndicator)
    }
    
    
    // MARK: Search
    func setupSearchBar() {
        let color = UIColor(rgb: 0xADB3C0)
        searchBarTxt.attributedPlaceholder = NSAttributedString(string: "Name, Email, Phone or QR code", attributes: [NSAttributedString.Key.foregroundColor: color])
        searchBarTxt.setPadding(left: 20, right: 0)
    }
    
    
    


    @IBAction func searchBarDidChange(_ sender: UITextField) {
        guard let query = sender.text else {return}
        if query == "" {
            self.loadData()
        } else {
            User.searchUsers(queryString: query){ (users) in
                guard let users = users else {return}
                self.refillTableUserList(userList: users)
            }
            self.table.reloadData()
        }
    }

    func loadTableUserSearchResult(data: Any) -> Void {
        self.processingIndicator.stopAnimating()
    }
    
    // MARK: Load data w/o search
    func loadData(){
        processingIndicator.startAnimating()
        user.getAll(id: self.user!.userId)
        { (json, code, error) in
            self.processingIndicator.stopAnimating()
            guard code == 200,
            let userList = json?["data"] as? [[String:Any]]
            else {return}
            
            self.refillTableUserList(userList: userList)
        }
    }
    func refillTableUserList(userList: [User]) {
        self.requestBuilderProfileList.removeAll()
        for user in userList {
            if user.userId != self.user.userId {
                self.requestBuilderProfileList.append(user)
            }
        }
    }
    func refillTableUserList(userList: [[String:Any]]) {
        self.requestBuilderProfileList.removeAll()
        for userData in userList {
            guard let userFetched = User(data: userData) else {continue}
            if (userFetched.userId != self.user.userId){
                self.requestBuilderProfileList.append(userFetched)
            }
        }
        self.table.reloadData()
        self.processingIndicator.stopAnimating()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestBuilderProfileList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3",for : indexPath) as! RequestTableViewCell
        cell.selectionStyle = .none
        let tableUser = requestBuilderProfileList[indexPath.row]
        tableUser.fetchProfilePic { (image, imageBase64) in
            DispatchQueue.main.async {
                if let image = image {
                    cell.profileImageView.image = image
//                    tableUser.profileImgBase64?.toUIImage() = image
                }else {
                    cell.profileImageView.image = UIImage(named: "default_profile")
                }
            }
        }
        
        cell.profileNameLbl.text = tableUser.firstName! + " " + tableUser.lastName!

        processingIndicator.stopAnimating()
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "AmountViewController") as! AmountViewController
        
        let tableUser = requestBuilderProfileList[indexPath.row]
        nextVC.modalPresentationStyle = .overFullScreen
        requestBuilder.payer = tableUser
        nextVC.requestBuilder = requestBuilder
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
