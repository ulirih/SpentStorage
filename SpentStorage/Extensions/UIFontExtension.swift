//
//  UIFontExtension.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 08.11.2022.
//

import Foundation
import UIKit

enum NunitoFontType: String {
    case bold = "NunitoSans-Bold"
    case regular = "NunitoSans-Regular"
    case light = "NunitoSans-Light"
    case extralight = "NunitoSans-ExtraLight"
}

extension UIFont {
    static func getHelveticFont(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont()
    }
    
    static func getNunitoFont(type: NunitoFontType, size: CGFloat = 16) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont()
    }
}
