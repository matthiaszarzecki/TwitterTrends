//
//  UIColor-Extension.swift
//  TwitterTrends
//
//  Created by Zarzecki, Matthias on 17.05.18.
//  Copyright © 2018 Zarzecki, Matthias. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorFromHexString(_ hex: String) -> UIColor {
        var colorString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if colorString.hasPrefix("#") {
            colorString.remove(at: colorString.startIndex)
        }
        
        if colorString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
