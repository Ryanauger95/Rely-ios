//
//  SettingsViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/5/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var linkbankView: UIView!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var preferencesView: UIView!
    @IBOutlet weak var exportView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var aboutView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Settings"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        self.styleDarkNav()
        self.signOutButton.blueStyle()
        self.title = "Settings"

        
        // Set tab bar icon
        self.tabBarItem.selectedImage =
            UIImage(named: "settings color")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.title = ""
        
        // Add functionality for all of the options
        let linkbankGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateBank))
        self.linkbankView.isUserInteractionEnabled = true
        self.linkbankView.addGestureRecognizer(linkbankGesture)
        
        let completedGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateUnderConstruction))
        self.completedView.isUserInteractionEnabled = true
        self.completedView.addGestureRecognizer(completedGesture)
        
        let preferencesGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateUnderConstruction))
        self.preferencesView.isUserInteractionEnabled = true
        self.preferencesView.addGestureRecognizer(preferencesGesture)
        
        let exportGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateUnderConstruction))
        self.exportView.isUserInteractionEnabled = true
        self.exportView.addGestureRecognizer(exportGesture)
        
        let notificationGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateUnderConstruction))
        self.notificationView.isUserInteractionEnabled = true
        self.notificationView.addGestureRecognizer(notificationGesture)
        
        let aboutGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateUnderConstruction))
        self.aboutView.isUserInteractionEnabled = true
        self.aboutView.addGestureRecognizer(aboutGesture)

        
    }
    @objc func navigateBank() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BankLinkViewController") as! BankLinkViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func navigateUnderConstruction() {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BlankVC") else {
            return
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }


    @IBAction func signOutAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirm!", message: "Do you want to signout now?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            UserAuthHandler().userLogout()
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "EntryNavigationController") as! UINavigationController
            self.present(nextVC, animated: true, completion: nil)
        }

        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in}
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
