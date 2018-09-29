//
//  UIControl+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-22.
//
//

import Foundation

internal extension UIControl {
    func applyToSuperclass(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .contentVerticalAlignment(let alignment):
                contentVerticalAlignment = alignment
            case .contentHorizontalAlignment(let alignment):
                contentHorizontalAlignment = alignment
            case .enabled(let enabled):
                isEnabled = enabled
            case .selected(let selected):
                isSelected = selected
            case .highlighted(let highlighted):
                isHighlighted = highlighted
            case .targets(let actors):
                actors.forEach { addTarget(using: $0) }
            default:
                break
            }
        }
    }
}
