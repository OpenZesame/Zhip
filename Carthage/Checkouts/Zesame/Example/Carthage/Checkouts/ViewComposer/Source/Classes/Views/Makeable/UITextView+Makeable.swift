//
//  UITextView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

extension UITextView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UITextView {
        return UITextView(frame: .zero)
    }
}
