//
//  UILabel+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

extension UILabel: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UILabel {
        return UILabel(frame: .zero)
    }
}
