//
//  UIView+Distance.swift
//  Rely
//
//  Created by Ryan Auger on 7/30/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    
    /// Create a rectangle using two points
    ///
    /// - parameter self: The first point to use
    /// - parameter point: The second point to utilize
    ///
    /// - returns: A rectangle using the two points as opposite corners
    func rect(from point: CGPoint) -> CGRect {
        return CGRect(x: min(self.x, point.x),
                      y: min(self.y, point.y),
                      width: abs(self.x - point.x),
                      height: abs(self.y - point.y))
    }
    
    /// Get the distance between two points
    ///
    /// - parameter self: The first point to use
    /// - parameter point: The second point to utilize
    ///
    /// - returns: A float value of the distance between points
    func distance(point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return sqrt(dx*dx + dy*dy)
    }
}
