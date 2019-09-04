//
//  Person.swift
//  Rely
//
//  Created by Ryan Auger on 2/11/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
import UIKit
class Person {
    
    //MARK: Properties
    
    private var name: String?
    private var photo: UIImage?
    private var rating: Int?
    
    init(){}
    
    init(name: String, photo: UIImage?, rating: Int) {
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    func getName() -> String{
        return self.name!
    }
    
    func getPhoto() -> UIImage{
        return self.photo!
    }
    
    func getRate() -> Int{
        return self.rating!
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func setPhoto(photo: UIImage){
        self.photo = photo
    }
    
    func setRating(rate: Int){
        self.rating = rate
    }
        
}
