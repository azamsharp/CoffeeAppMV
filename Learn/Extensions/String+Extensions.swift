//
//  String+Extensions.swift
//  Learn
//
//  Created by Mohammad Azam on 10/5/22.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil ? true: false 
    }
    
    func isLessThan(_ value: Double) -> Bool {
        guard let number = Double(self) else {
            return false
        }
        
        return number < value
    }
    
}
