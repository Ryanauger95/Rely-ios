//
//  CurrencyConversionProtocol.swift
//  Rely
//
//  Created by Ryan Auger on 9/4/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

protocol CurrencyConversionProtocol {
    // To string conversions
    func payerTotalString() -> String
    func collectorTotalString() -> String
    func reserveString() -> String
    func totalFeeString() -> String
    
    // To Float conversions
    func payerTotalFloat() -> Float
    func collectorTotalFloat() -> Float
    func reserveFloat() -> Float
    func totalFeeFloat() -> Float
    
}

extension Txn {
    // To string
    func payerTotalString() -> String {
        return String(format: "%.2f", Double(self.payerTotal)/100)
    }
    func collectorTotalString() -> String {
        return String(format: "%.2f", Double(self.collectorTotal)/100)
    }
    func reserveString() -> String {
        return String(format:"%.2f", Double(self.reserve)/100)
    }
    func totalFeeString() -> String {
        return String(format:"%.2f", Double(self.totalFee)/100)
    }
    
    // To float
    func payerTotalFloat() -> Float {
        return Float(self.payerTotal)/100
    }
    func collectorTotalFloat() -> Float {
        return Float(self.collectorTotal)/100
    }
    func reserveFloat() -> Float {
        return Float(self.reserve)/100
    }
    func totalFeeFloat() -> Float {
        return Float(self.totalFee)/100
    }
}
