//
//  UIViewController+Alert.swift
//  Rely
//
//  Created by Ryan Auger on 7/14/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

enum ALERT {
    case LOGIN
    case SIGNUP
    
}
enum STATUS {
    case SUCCESS
    case FAILURE
}

extension UIViewController {
    func alertTitle(alertType: ALERT, isSuccess: Bool) -> String {
        switch alertType {
        case .LOGIN, .SIGNUP:
            return (isSuccess) ? "Success" : "Failed"
        }
    }
    func alertMessage(alertType: ALERT, isSuccess: Bool) -> String {
        switch alertType {
        case .LOGIN, .SIGNUP:
            return (isSuccess) ? "" : ""
        }
    }
    func postAlert(alertType: ALERT, isSuccess: Bool, user: User?) {
        let title = alertTitle(alertType: alertType, isSuccess: isSuccess)
        let message = alertMessage(alertType: alertType, isSuccess: isSuccess)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            guard !isSuccess else {return}
            if user?.phone == nil {
                let storyboard = UIStoryboard(name: "Verification", bundle: nil)
                let nextVC = storyboard.instantiateViewController(withIdentifier: "MobileVerificationViewController")
                let navigationController = UINavigationController(rootViewController: nextVC)
                self.present(navigationController, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbar = (storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! UITabBarController)
                self.present(tabbar, animated: true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    typealias VoidFunc = () -> Void
    typealias AlertFunc = (UIAlertAction) -> Void
    func basicAlert(type: STATUS, completion: VoidFunc?) {
        let title = (type == .SUCCESS) ? "Success" : "Failure"
        let message = (type == .SUCCESS) ?
        "Successfully submitted!" : "An error occured, please try again later."
        self.alert(title: title, message: message, completion: completion)
    }
    func alert(title: String, message: String, completion: VoidFunc?) {
        self.alert(title: title, message: message, completion: {(UIAlertAction) in
            guard let completion = completion else {return}
            completion()
        })
    }
    func alert(title: String, message: String, completion: @escaping AlertFunc) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
}
