//
//  DateUtils.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/12/25.
//

import Foundation


public func currentDateTime() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}
