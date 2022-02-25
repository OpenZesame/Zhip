//
//  Colors.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import Foundation
import SwiftUI

public extension Color {
    static let appBackground: Self = .deepBlue
}

public extension Double {
    static let defaultOpacity: Self = 1
}

public extension Color {
    enum Hex: UInt32 {
        case tealHex = 0x00A88D

        case darkTeal = 0x0F675B
        case mellowYellow = 0xFFD14C
        case deepBlue = 0x1F292F
        case bloodRed = 0xFF4C4F
        case asphaltGrey = 0x40484D
        case silverGrey = 0x6F7579

        // Dark color used for navigation bar
        case dusk = 0x192226
    }
    
    init(hex: Hex, opacity: Double = .defaultOpacity) {
        self.init(hex: hex.rawValue, opacity: opacity)
    }
    
    init(hex: UInt32, opacity: Double = .defaultOpacity) {
        func value(shift: Int) -> Double {
            Double((hex >> shift) & 0xff) / 255
        }

        self.init(
            red: value(shift: 16),
            green: value(shift: 08),
            blue: value(shift: 00),
            opacity: opacity
        )
    }
}

public extension Color {
    static let teal = Self(hex: .tealHex)
    static let darkTeal = Self(hex: .darkTeal)
    static let deepBlue = Self(hex: .deepBlue)
    static let mellowYellow = Self(hex: .mellowYellow)
    static let bloodRed = Self(hex: .bloodRed)
    static let asphaltGrey = Self(hex: .asphaltGrey)
    static let silverGrey = Self(hex: .silverGrey)
    static let dusk = Self(hex: .dusk)
}
