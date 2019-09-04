//
//  CancelDealViewController.swift
//  Rely
//
//  Created by Ryan Auger on 7/19/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class CancelDealViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var reserveLbl: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var user: User!
    var userRole: DEAL_ROLE!
    var deal: Txn!
    var cancelType: cancelType!
    
    let FORFEIT_RESERVE = "Forfeit Reserve"
    let KEEP_RESERVE = "Keep Reserve"
    let RETURN_RESERVE = "Reserve will be returned"
    var pickerOptions : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        

        self.reserveLbl.text = self.deal.reserveString()
        
        self.cancelButton.isEnabled = false
        
        switch self.deal.dealState{
        case .PENDING:
            // Before the deal is accepted by the other party,
            // the reserve is always kept by the payer -- it
            // hasn't been moved into holding
            self.cancelButton.isEnabled = true
            self.pickerOptions.append(RETURN_RESERVE)
            self.cancelType = .returnReserve
            self.cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
            break
        case .PROGRESS:
            // Once in progress, either party can elect to cancel the deal
            // and either keep or forfeit the reserve
            self.cancelButton.isEnabled = true
            if (userRole == .PAYER) {
                self.pickerOptions.append(FORFEIT_RESERVE)
            } else {
                self.pickerOptions.append(RETURN_RESERVE)
            }
            self.cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
            break
        case .REVIEW:
            // Cannot cancel a deal once it goes to review
            self.cancelButton.isEnabled = false
            break

            //For these cases, we shouldn't be here
        case .DISPUTE:
            fallthrough
        case .TIMEOUT:
            fallthrough
        case .CANCELLED:
            fallthrough
        case .COMPLETE:
            fallthrough
        @unknown default:
            break
        }

    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        // Cancel the job
        self.deal.updateState(newState: DEAL_STATE.CANCELLED){(json, code, err) in
            if (code != 200) {
                self.alert(title: "Failed", message: "Couldn't cancel deal", completion: {() in
                    self.dismiss(animated: true, completion: nil)
                })
            }
            self.alert(title: "Success", message: "Canceled Deal", completion: {() in
                self.dismiss(animated: true, completion: nil)
                guard let navVC = self.presentingViewController as? UINavigationController else {
                    return
                }
                navVC.popToRootViewController(animated: true)
            })
        }
    }
    
    @objc func cancelProgress() {
    }

    // Picker View
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return self.pickerOptions.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
}
