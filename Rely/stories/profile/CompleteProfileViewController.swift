//
//  SetupProfileViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/29/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit
import LinkKit


class CompleteProfileViewController: ImagePickerViewController{
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var linkAccountView: View!
    @IBOutlet weak var linkAccountSuccess: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        self.styleClearNav()
        self.outerView.layer.cornerRadius = 10
        self.linkAccountSuccess.image = nil

        //
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationItem.leftBarButtonItem = nil
        
        // link bank account
        let linkbankGesture = UITapGestureRecognizer(target: self, action: #selector(self.linkBank))
        self.linkAccountView.isUserInteractionEnabled = true
        self.linkAccountView.addGestureRecognizer(linkbankGesture)

    }
    
    // Go back to whence we came
    @IBAction func skipAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // LINK BANK ACCOUNT
    @objc func linkBank() {
//        self.presentPlaidLinkWithSharedConfiguration()
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "BankLinkViewController") as! BankLinkViewController
        let exitButton = UIButton(frame: CGRect(x: nextVC.view.frame.width - 50, y: 40, width: 50, height: 50))
        exitButton.setTitle("X", for: .normal)
        exitButton.addTarget(nextVC, action: #selector(nextVC.dismissModal), for: .touchUpInside)
        nextVC.view.addSubview(exitButton)
        self.present(nextVC, animated: true)
    }
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
