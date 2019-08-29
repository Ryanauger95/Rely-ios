//
//  Date+toString.swift
//  RelySIGNATURE
//
//  Created by Ryan Auger on 6/7/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
