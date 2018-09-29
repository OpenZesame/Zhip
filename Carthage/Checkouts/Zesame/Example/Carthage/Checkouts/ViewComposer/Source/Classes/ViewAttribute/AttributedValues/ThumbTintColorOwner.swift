//
//  ThumbTintColorOwner.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

public protocol ThumbTintColorOwner: class {
    var thumbTintColor: UIColor? { get set}
}

extension UISlider: ThumbTintColorOwner {}
extension UISwitch: ThumbTintColorOwner {}

internal extension ThumbTintColorOwner {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .thumbTintColor(let color):
                self.thumbTintColor = color
            default:
                break
            }
        }
    }
}
