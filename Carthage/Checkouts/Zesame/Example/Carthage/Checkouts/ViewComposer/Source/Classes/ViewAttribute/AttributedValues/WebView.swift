//
//  WebView.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import UIKit
import WebKit

protocol WebView {
    @discardableResult
    func load(_ request: URLRequest) -> WKNavigation?
}

extension WKWebView: WebView {}
extension UIWebView: WebView {
    @discardableResult
    func load(_ request: URLRequest) -> WKNavigation? {
        loadRequest(request)
        return nil
    }
}

internal extension WebView {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .webPage(let request):
                load(request)
            default:
                break
            }
        }
    }
}
