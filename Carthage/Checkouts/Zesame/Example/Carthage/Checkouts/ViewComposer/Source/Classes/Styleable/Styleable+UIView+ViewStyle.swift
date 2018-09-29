//
//  Styleable+UIView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

public extension Styleable where Self: UIView, StyleType == ViewStyle {
    func setup(with style: StyleType) {
        translatesAutoresizingMaskIntoConstraints = false
        style.install(on: self)
        setupConstraints(with: style)
    }
    
    func layoutSubviews(with style: StyleType) {
        privateLayoutSubviews(with: style)
        customLayoutSubviews(with: style)
    }
    
    func customLayoutSubviews(with style: StyleType) {}
}

public extension Styleable where Self: UIView, StyleType == ViewStyle {
    func privateLayoutSubviews(with style: StyleType) {
        guard let rounding: CornerRounding = style.value(.roundedBy) else { return }
        rounding.apply(to: self)
    }
    
    func setupConstraints(with style: StyleType) {
        if let height: CGFloat = style.value(.height) {
            addConstraint(heightAnchor.constraint(equalToConstant: height))
        }
        
        if let width: CGFloat = style.value(.width) {
            addConstraint(widthAnchor.constraint(equalToConstant: width))
        }
    }
}

