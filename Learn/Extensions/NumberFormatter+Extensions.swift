//
//  NumberFormatter+Extensions.swift
//  Learn
//
//  Created by Mohammad Azam on 10/5/22.
//

import Foundation

extension NumberFormatter {
    
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
}
