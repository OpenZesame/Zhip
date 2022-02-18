//
//  Fonts.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-16.
//

import SwiftUI

public extension Font {
    enum Size: CGFloat {
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
