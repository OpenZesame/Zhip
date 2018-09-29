//
//  UISlider+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

extension UISlider: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UISlider {
        return UISlider(frame: .zero)
    }
}
