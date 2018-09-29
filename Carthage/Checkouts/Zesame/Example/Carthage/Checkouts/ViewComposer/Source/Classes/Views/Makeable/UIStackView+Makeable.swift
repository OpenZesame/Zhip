//
//  UIStackView+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

extension UIStackView: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIStackView {
        return UIStackView(frame: .zero)
    }
    
    public func postMake(_ style: StyleType) {
        setupArrangedSubviews(with: style)
    }
}

extension UIStackView {
    public func setupArrangedSubviews(with style: ViewStyle) {
        guard let optionalViews: [UIView?] = style.value(.views) else { return }
        let views: [UIView] = optionalViews.removeNils()
        views.forEach { addArrangedSubview($0) }
    }
}

