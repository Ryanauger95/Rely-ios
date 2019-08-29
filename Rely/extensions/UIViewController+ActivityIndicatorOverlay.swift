//
//  UIViewController+ActivityIndicatorOverlay.swift
//  Rely
//
//  Created by Ryan Auger on 7/10/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension UIViewController {
    private struct activity {
        static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        
        static var activityView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    var activityIndicator: UIActivityIndicatorView {
        get {
            return objc_getAssociatedObject(self, &activity.activityIndicator) as! UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &activity.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var activityView : UIView {
        get {
            return objc_getAssociatedObject(self, &activity.activityView) as! UIView
        }
        set {
            objc_setAssociatedObject(self, &activity.activityView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func addActivity() {
        self.view.fadeTransition(0.5)
        self.activityView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.activityView.backgroundColor = UIColor(rgb: 0xF8F8F8, alpha: 0.7)
        self.activityView.center = self.view.center
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.center = self.activityView.center
        self.activityIndicator.startAnimating()
        self.activityView.addSubview(activityIndicator)
        self.view.addSubview(activityView)

    }
    func removeActivity(){
        UIView.animate(withDuration: 1, animations: {self.activityView.alpha = 0.0},
                                   completion: {(value: Bool) in
                                    self.activityView.removeFromSuperview()
        })
    }
}
