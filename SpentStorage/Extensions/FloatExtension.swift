//
//  FloatExtension.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 08.11.2022.
//

import Foundation

extension Float {
    func toFormattedAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    func toFormattedPercent() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.maximumFractionDigits = 2
        
        return (formatter.string(from: NSNumber(value: self)) ?? "0") + " %"
    }
}
