//
//  UISegmentedControl+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

extension UISegmentedControl: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UISegmentedControl {
        return UISegmentedControl(frame: .zero)
    }
}
