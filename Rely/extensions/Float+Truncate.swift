//
//  Float+Truncate.swift
//  Rely
//
//  Created by Ryan Auger on 9/4/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension Float
{
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
}
