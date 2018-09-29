//
//  UISlider+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UISlider {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .sliderValue(let value):
                self.value = Float(value)
            case .sliderRange(let range):
                self.minimumValue = Float(range.lowerBound)
                self.maximumValue = Float(range.upperBound)
            default:
                break
            }
        }
    }
}
