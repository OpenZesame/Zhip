//
//  WKWebView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import UIKit
import WebKit

extension WKWebView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> WKWebView {
        return WKWebView(frame: .zero)
    }
}
