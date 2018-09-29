//
//  UIActivityIndicatorView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

internal extension UIActivityIndicatorView {
    func apply(_ viewStyle: ViewStyle) {
        viewStyle.attributes.forEach {
            switch $0 {
            case .spin(let animating):
                if animating {
                    startAnimating()
                } else {
                    stopAnimating()
                }
            case .hidesWhenStopped(let hides):
                hidesWhenStopped = hides
            case .spinnerStyle(let spinnerStyle):
                style = spinnerStyle
            case .spinnerScale(let scaleFactor):
                scale(factor: scaleFactor)
            default:
                break
            }
        }
    }
}

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
