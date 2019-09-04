//
//  DisputeSliderView.swift
//  Rely
//
//  Created by Ryan Auger on 9/4/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class DisputeSliderView: UIView {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var selectedLabel: UILabel!

    var txn: Txn!
    var collectorName: String!
    var disputeDelegate: DisputeProtocol!
    
    static func instantiate(superView: UIView, txn: Txn, delegate: DisputeProtocol) -> DisputeSliderView {
        // create the View
        let disputeView = Bundle.main.loadNibNamed("DisputeSlider", owner: self, options: nil)?.first as! DisputeSliderView
        
        // set properties
        disputeView.txn = txn
        disputeView.center = superView.center
        disputeView.disputeDelegate = delegate
        
        return disputeView
    }
    
    override func didMoveToSuperview() {
        self.slider.minimumValue = 0
        self.slider.maximumValue = txn.collectorTotalFloat()
        self.slider.value = txn.reserveFloat()
        

        guard
            let firstName = txn.collector.firstName,
            let lastName = txn.collector.lastName
            else {
                self.dismiss(self)
                return
        }
        self.collectorName = "\(firstName) \(lastName)"
        self.setSelectedStr(value: self.slider.value)
    }
    
    func setSelectedStr(value: Float){
        self.selectedLabel.text = String(format: "%@ receives $%.2f", self.collectorName, value.truncate(places: 2))
    }
    
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if (sender.value < txn.reserveFloat()){
            sender.value = txn.reserveFloat()
        }
        self.setSelectedStr(value: sender.value)
    }
    @IBAction func dismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func dispute(_ sender: Any) {
        let collectorAmount = Int(self.slider.value * 100)
        let payerAmount = self.txn.collectorTotal - collectorAmount
        if(disputeDelegate != nil){
            disputeDelegate.dispute(collectorAmount: collectorAmount, payerAmount: payerAmount)
        }
    }
}
