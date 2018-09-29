//
//  UIImageView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

extension UIImageView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIImageView {
        return UIImageView(frame: .zero)
    }
}
