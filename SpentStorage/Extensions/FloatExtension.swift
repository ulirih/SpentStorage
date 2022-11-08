//
//  FloatExtension.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 08.11.2022.
//

import Foundation

extension Float {
    func toFormattedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
