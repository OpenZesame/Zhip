//
//  UISegmentedControl+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UISegmentedControl {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .segments(let segments):
                segments.add(to: self)
            default:
                break
            }
        }
    }
}
