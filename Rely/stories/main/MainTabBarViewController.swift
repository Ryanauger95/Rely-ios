//
//  MainTabBarViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/30/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit
import Intercom

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleDarkNav()
        self.delegate = self
        
    }
    
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController.restorationIdentifier == "Intercom"){
//            Intercom.presentHelpCenter()
            Intercom.presentMessenger()
            return false
        }
        return true
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        return
    }


//    func tabbar
}
