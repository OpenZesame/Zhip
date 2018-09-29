//
//  UIButton+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

extension UIButton: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIButton {
        return UIButton(type: .custom)
    }
}
