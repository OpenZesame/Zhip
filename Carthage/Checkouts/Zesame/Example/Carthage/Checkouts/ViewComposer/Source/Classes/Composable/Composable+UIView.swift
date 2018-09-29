//
//  Composable+UIView.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Composable where Self: UIView, StyleType == ViewStyle {
    func compose(with style: StyleType) {
        setup(with: style) /* Calling `setup` method in `Styleable` protocl */
        setupSubviews(with: style) /* Calling "optional" method in `Composable` */
    }
}
