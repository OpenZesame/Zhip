//
//  UIActivityIndicatorView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

extension UIActivityIndicatorView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }
}
