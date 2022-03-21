//
//  Fonts.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-16.
//

import SwiftUI

public extension Font {
    enum Size: CGFloat {
        case 𝟙𝟜 = 14
        case 𝟙𝟞 = 16
        case 𝟙𝟠 = 18
        case 𝟚𝟘 = 20

        case 𝟛𝟜 = 34

        case 𝟜𝟠 = 48
        case 𝟠𝟞 = 86
    }
   
    /// Namespace only
    struct Zhip {
        fileprivate init() {}
    }
    static let zhip = Zhip()
    
    static func barlow(
        _ size: Size,
        _ weight: Font.Weight = .regular
    ) -> Self {
        Font.custom("Barlow", size: size.rawValue)
        .weight(weight)
    }
}

#if os(iOS)
public extension Font.Zhip {
    /// Namespace only
    struct iOSFont {
        fileprivate init() {}
    }
    static let iOS = iOSFont()
}


func makeUI(
    _ size: Font.Size,
    _ name: FontBarlow
) -> UIFont {
    guard let customFont = UIFont(name: name.rawValue, size: size.rawValue) else {
        fatalError("Failed to load custom font named: '\(name.rawValue)'")
    }
    return customFont
}

enum FontBarlow: String {
    case regular = "Barlow-Regular"
    case medium = "Barlow-Medium"
    case bold = "Barlow-Bold"
    case semiBold = "Barlow-SemiBold"
}


public extension Font.Zhip.iOSFont {
    var tabNormal: UIFont { makeUI(.𝟙𝟜, .regular) }
    var tabSelected: UIFont { makeUI(.𝟙𝟜, .bold) }
//    var hint: UIFont { makeUI(.𝟙𝟞, .medium) }
//    var valueTitle: UIFont { makeUI(.𝟙𝟞, .regular) }
//    var value: UIFont { makeUI(.𝟙𝟠, .bold) }
//    var body: UIFont { makeUI(.𝟙𝟠, .regular) }
//    var title: UIFont { makeUI(.𝟙𝟠, .semiBold) }
//    var callToAction: UIFont { makeUI(.𝟚𝟘, .semiBold) }
//    var header: UIFont { makeUI(.𝟛𝟜, .bold) }
//    var impression: UIFont { makeUI(.𝟜𝟠, .bold) }
//    var bigBang: UIFont { makeUI(.𝟠𝟞, .semiBold) }
}
#endif

public extension Font.Zhip {
    
    var bigBang: Font {
        .barlow(.𝟠𝟞, .semibold)
    }
    
    var impression: Font {
        .barlow(.𝟜𝟠, .bold)
    }
    
    var header: Font {
        .barlow(.𝟛𝟜, .bold)
    }
    
    var callToAction: Font {
        .barlow(.𝟚𝟘, .semibold)
    }
    
    var body: Font {
        .barlow(.𝟙𝟠, .regular)
    }
    
    var title: Font {
        .barlow(.𝟙𝟠, .semibold)
    }
    
    var hint: Font {
        .barlow(.𝟙𝟞, .medium)
    }

}
