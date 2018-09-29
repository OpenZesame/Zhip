//
//  UIStackView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UIStackView {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .alignment(let alignment):
                self.alignment = alignment
            case .axis(let axis):
                self.axis = axis
            case .spacing(let spacing):
                self.spacing = spacing
            case .distribution(let distribution):
                self.distribution = distribution
            case .baselineRelative(let isBaselineRelativeArrangement):
                self.isBaselineRelativeArrangement = isBaselineRelativeArrangement
            case .marginsRelative(let isLayoutMarginsRelativeArrangement):
                self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
            case .margin(let marginExpressible):
                let margin = marginExpressible.margin
                self.layoutMargins = margin.insets
                self.isLayoutMarginsRelativeArrangement = margin.isRelative
            default:
                break
            }
        }
    }
}
