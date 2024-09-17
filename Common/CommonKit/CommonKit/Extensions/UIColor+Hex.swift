//
//  UIColor+Hex.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 2.09.2024.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

extension UIColor {
    public struct NavigationBarColor {
        public static let Background = UIColor(hex: 0x1D1D1D)
    }
    
    public struct CollectionViewColor {
        public static let Background = UIColor(hex: 0x151515)
    }
    
    public struct TabBarColor {
        public static let TabBarBackground = UIColor(hex: 0x282828)
        public static let TabBarTint = UIColor(hex: 0x6EC46F)
    }
    
    public struct RatingViewColor {
        public static let RatingLabelGreen = UIColor(hex: 0x6EC470)
        public static let RatingLabelOrange = UIColor(hex: 0xEF874A)
        public static let RatingLabelRed = UIColor(hex: 0xB9534F)
        public static let RatingViewGreen = UIColor(hex: 0x344F35)
        public static let RatingViewOrange = UIColor(hex: 0x463124)
        public static let RatingViewRed = UIColor(hex: 0x3B2626)
    }
    
    public struct SearchBarColor {
        public static let Background = UIColor(hex: 0x1D1D1D)
        public static let TextfieldBackground = UIColor(hex: 0x323235)
        public static let Cursor = UIColor(hex: 0x4BC766)
        public static let Text = UIColor(hex: 0x97979D)
    }

    public struct FavoriteButtonColor {
        public static let Green = UIColor(hex: 0x4BC766)
        public static let White = UIColor(hex: 0xFFFFFF)
        public static let Background = UIColor(hex: 0x151515)
    }
    
    public struct PlatformButtonColor {
        public static let Background = UIColor(hex: 0x2D2D2D)
    }
    
    public struct LoadingIndicatorColor {
        public static let Tint = UIColor(hex: 0x6EC470)
    }
    
    public struct GameCellColor {
        public static let TextGray = UIColor(hex: 0x757575)
    }
}
