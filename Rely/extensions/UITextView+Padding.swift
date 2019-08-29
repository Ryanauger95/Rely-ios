//
//  UITextView+Padding.swift
//  Rely
//
//  Created by Ryan Auger on 7/9/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func setPadding(top: CGFloat? = 0.0, left: CGFloat? = 0.0, bottom: CGFloat? = 0.0, right: CGFloat? = 0.0){
        self.textContainerInset =
            UIEdgeInsets(top: top!,left: left!,bottom: bottom!,right: right!);
    }
}
