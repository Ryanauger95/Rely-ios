//
//  DateOfBirth.swift
//  Rely
//
//  Created by Ryan Auger on 9/3/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class DateOfBirthView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerChanged(_ sender: Any) {
        print(datePicker.date)
    }
    
}
