//
//  String+toJpeg.swift
//  reli
//
//  Created by Ryan Auger on 8/27/19.
//  Copyright © 2019        . All rights reserved.
//

import Foundation
import UIKit

extension String{
    func toUIImage() -> UIImage?{
        guard
            let decoded = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {return nil}
        return UIImage(data: decoded)
    }
}
