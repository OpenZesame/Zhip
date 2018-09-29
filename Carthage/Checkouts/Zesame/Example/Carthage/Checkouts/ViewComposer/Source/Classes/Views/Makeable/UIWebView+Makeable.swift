//
//  UIWebView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

extension UIWebView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIWebView {
        return UIWebView(frame: .zero)
    }
}
