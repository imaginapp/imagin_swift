//
//  Colors.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import SwiftUI

extension Color {
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        let alpha = hex > 0xFFFFFF ? Double((hex >> 24) & 0xFF) / 255.0 : 1.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    init(hexStr: String) {
        let hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static let imaginBlack: Color = .init(hex: 0xff2d3436)
    static let imaginWhite: Color = .init(hex: 0xfff4f8f9)
    static let imaginYellow: Color = .init(hex: 0xffffeb3b)
    static let imaginHeartRed: Color = .init(hex: 0xffff5252)
    
//    https://angrytools.com/gradient/
    static let gradColorYellow = Color(red: 255/255, green: 255/255, blue: 0/255);
    static let gradColorBlue = Color(red: 0/255, green: 188/255, blue: 212/255);
    static let gradColorRed = Color(red: 238/255, green: 130/255, blue: 131/255);
    
    static let gradColorYellowDark = Color(red: 105/255, green: 105/255, blue: 19/255);
    static let gradColorBlueDark = Color(red: 13/255, green: 79/255, blue: 87/255);
    static let gradColorRedDark = Color(red: 102/255, green: 63/255, blue: 63/255);
}

extension Gradient {
    static let imaginGradient = Gradient(colors: [Color.imaginYellow, Color.imaginBlack]);

    static let threeColorGradient = Gradient(colors: [ Color.gradColorYellow, Color.gradColorBlue, Color.gradColorRed]);
    static let threeColorGradientDark = Gradient(colors: [ Color.gradColorYellowDark, Color.gradColorBlueDark, Color.gradColorRedDark]);
    static let threeColorAngled =  LinearGradient(
        gradient: threeColorGradient,
        startPoint: .init(x: 0.85, y: 0.15),
             endPoint: .init(x: 0.15, y: 0.85)
      )
    static let threeColorAngledDark =  LinearGradient(
        gradient: threeColorGradientDark,
        startPoint: .init(x: 0.85, y: 0.15),
             endPoint: .init(x: 0.15, y: 0.85)
      )
    static let imaginColorAngled =  LinearGradient(
        gradient: imaginGradient,
        startPoint: .init(x: 0.85, y: 0.15),
             endPoint: .init(x: 0.15, y: 0.85)
      )
}
