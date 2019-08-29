//
//  MainTabBarViewController.swift
//  Rely
//
//  Created by Ryan Auger on 6/30/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleDarkNav()
        self.delegate = self
        
    }
    
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }


}
