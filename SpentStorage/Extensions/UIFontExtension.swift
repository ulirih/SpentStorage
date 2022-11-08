//
//  UIFontExtension.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 08.11.2022.
//

import Foundation
import UIKit

extension UIFont {
    static func getHelveticFont(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont()
    }
}
