//
//  DoubleExtensions.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 21.11.2022.
//

import Foundation

extension Double {

    func since1970ToDays() -> Double {
        return self / 60 / 60 / 24
    }
    
    func since1970DaysToDate() -> Date {
        return Date(timeIntervalSince1970: self * 60 * 60 * 24)
    }
}
