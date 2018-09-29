//
//  UIProgressView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

extension UIProgressView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIProgressView {
        return UIProgressView(progressViewStyle: .default)
    }
}
