//
//  UITextField+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UITextField {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .borderStyle(let style):
                borderStyle = style
            case .background(let image):
                background = image
            case .disabledBackground(let image):
                disabledBackground = image
            case .clearButtonMode(let mode):
                clearButtonMode = mode
            case .leftView(let view):
                leftView = view
            case .leftViewMode(let mode):
                leftViewMode = mode
            case .rightView(let view):
                rightView = view
            case .rightViewMode(let mode):
                rightViewMode = mode
            default:
                break
            }
        }
    }
}
