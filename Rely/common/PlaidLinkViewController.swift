//
//  PlaidLinkVC.swift
//  Rely
//
//  Created by Ryan Auger on 6/11/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import UIKit
import LinkKit

class PlaidLinkViewController: UIViewController, PLKPlaidLinkViewDelegate {
    public typealias handleSuccessCbType = ( (_ publicToken : String, _ metadata: [String : Any]?) -> Void)
    var handleSuccessWithToken : handleSuccessCbType? = nil
    
    public typealias handleErrorCbType = (( _ error: Error, _ metadata: [String: Any]? ) -> Void)
    var handleError : handleErrorCbType? = nil
    
    public typealias handleExitWithMetadataCbType = (( [String : Any]?)-> Void)
    var handleExitWithMetadata : handleExitWithMetadataCbType? = nil
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
            if (self.handleSuccessWithToken != nil) {
                self.handleSuccessWithToken!(publicToken, metadata)
            }
        }
    }
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                if (self.handleError != nil) {
                    self.handleError!(error, metadata)
                }
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                if (self.handleExitWithMetadata != nil) {
                    self.handleExitWithMetadata!(metadata)
                }
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
}
