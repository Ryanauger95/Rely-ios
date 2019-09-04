//
//  FeedbackViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/8/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var feedbackWordCount: UILabel!
    
    let maxWords = 250
    let placeHolderText = "What's on your mind?"
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleDarkNav()
        self.title = "Contact Us"

        // Set up Text Field

        // Set up UI Text View
        self.feedbackTextView.delegate = self
        self.feedbackTextView.addCorners()
        self.feedbackTextView.textColor = UIColor.lightGray
        self.feedbackTextView.text = placeHolderText
        self.feedbackTextView.setPadding(top:5, left: 5)

        // Set tab bar icon
//        self.tabBarItem.selectedImage =
//            UIImage(named: "feedback color")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "feedback")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.title = ""

        // Do any additional setup after loading the view.
        user = User(defaults: true)
        

    }
    
    @IBAction func submitFeedback(_ sender: Any) {
        guard (feedbackTextView.text != placeHolderText) else {return}
        MessagesApi().submitFeedback(userId: user.userId, message: feedbackTextView.text, completion: {(json, code, error) in
            guard
                let json = json,
                json["status"] as? String == "success"
            else {
                self.basicAlert(type: .FAILURE, completion: nil)
                return
            }
            self.basicAlert(type: .SUCCESS, completion: nil)
        })
        
    }
    
    // TextView Placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.wordCount() + text.count <= maxWords
    }
    func textViewDidChange(_ textView: UITextView) {
        self.feedbackWordCount.text =
            String(format: "%d/%d", textView.text.wordCount(), self.maxWords)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
    
}
