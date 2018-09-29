//
//  UIPickerView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

extension UIPickerView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIPickerView {
        return UIPickerView(frame: .zero)
    }
}
