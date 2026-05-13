//
//  Int+Extension.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 03/11/25.
//

import Foundation

extension Int {
    
    var asString: String {
        return String(self)
    }
    
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        
        return formatter.string(for: self) ?? self.asString
    }
}
