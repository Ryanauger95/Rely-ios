//
//  ContactViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/10/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // style the buttons
        self.callView.lightBlueStyle()
        self.textView.lightBlueStyle()
        self.emailView.lightBlueStyle()
        
        // set up buttons
        let callGesture = UITapGestureRecognizer(target: self, action:  #selector(self.call))
        self.callView.isUserInteractionEnabled = true
        self.callView.addGestureRecognizer(callGesture)
        
        let textGesture = UITapGestureRecognizer(target: self, action:  #selector(self.text))
        self.textView.isUserInteractionEnabled = true
        self.textView.addGestureRecognizer(textGesture)
        
        let emailGesture = UITapGestureRecognizer(target: self, action:  #selector(self.email))
        self.emailView.isUserInteractionEnabled = true
        self.emailView.addGestureRecognizer(emailGesture)
        
    }
    
    
    @objc func call() {
        guard
            let phone = self.user.phone,
            let link = URL(string: "tel://\(phone)") else { return }
        UIApplication.shared.open(link, options: [:], completionHandler: nil)
    }
    @objc func text() {
        guard
            let phone = self.user.phone,
            let link = URL(string: "sms:\(phone)") else { return }
        UIApplication.shared.open(link, options: [:], completionHandler: nil)
    }
    @objc func email() {
        guard
            let email = self.user.email,
            let link = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(link, options: [:], completionHandler: nil)
    }

    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

