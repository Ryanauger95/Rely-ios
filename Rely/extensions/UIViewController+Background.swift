//
//  UIViewController+Background.swift
//  Rely
//
//  Created by Ryan Auger on 7/10/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func styleDarkNav() {
        // style nav bar
        self.setNavTransparent(transparent: true)
        self.setNavColor(color: UIColor.white)
        self.navigationController?.navigationBar.topItem?.title = ""
        // Add in background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "ReliBackground")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}
