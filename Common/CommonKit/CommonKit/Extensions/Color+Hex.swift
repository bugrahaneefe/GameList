//
//  Color+Hex.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 10.09.2024.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue! & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    public struct PlatformButtonColor {
        public static let Background = Color(hex: "#2D2D2D")
        public static let Green = Color(hex: "#4BC766")
    }
    
    public struct GameCellBannerPlatformColor {
        public static let Background = Color(hex: "#1D1D1D")
        public static let Tint = Color(hex: "#D6D6D6")
    }
    
    public struct InformationViewColor {
        public static let Background = Color(hex: "#1D1D1D")
        public static let TitleTint = Color(hex: "#656565")
        public static let InfoTint = Color(hex: "#9F9F9F")
    }
    
    public struct DescriptionViewColor {
        public static let Background = Color(hex: "#1D1D1D")
        public static let DescriptionTint = Color(hex: "#656565")
        public static let TitleTint = Color(hex: "#FFFFFF")
    }
    
    public struct VisitButtonViewColor {
        public static let Background = Color(hex: "#1D1D1D")
        public static let TitleTint = Color(hex: "#FFFFFF")
    }
}
