//
//  UITextField+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

extension UITextField: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UITextField {
        return UITextField(frame: .zero)
    }
}
