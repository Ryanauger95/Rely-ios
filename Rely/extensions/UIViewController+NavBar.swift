//
//  UIViewController+NavBar.swift
//  Rely
//
//  Created by Ryan Auger on 7/10/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func styleClearNav() {
        self.setNavTransparent(transparent: true)
        self.setNavColor(color: UIColor.init(rgb: 0x393E46))
        self.replaceBackButton()
        if (self.isRootViewController()) {
            self.disableBackButton()
        }
    }
    func replaceBackButton() {
        // Set the Back button theme
        let button: UIButton = UIButton (type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "icons8-back.png"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(self.backButtonPressed as () -> Void), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0 , y: 0, width: 40, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func isRootViewController() -> Bool {
        return self.navigationController?.viewControllers.count == 1
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func disableBackButton(){
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil
    }
    
    func setNavColor(color: UIColor) {
        self.navigationController?.navigationBar.tintColor = color
        if ((self.navigationController?.navigationBar.titleTextAttributes) != nil) {
            self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] =   color
        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        }
    }
    
    func setNavTransparent(transparent: Bool){
        if (transparent) {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.view.backgroundColor = UIColor.white
        }
    }
}
