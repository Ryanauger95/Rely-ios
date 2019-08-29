//
//  String+WordCount.swift
//  Rely
//
//  Created by Ryan Auger on 7/14/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension String {
    func wordCount() -> Int{
        let spaces = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let words = self.components(separatedBy: spaces)
        return words.count
    }
}
