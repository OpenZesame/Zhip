//
//  UILabel+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UILabel {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .numberOfLines(let numberOfLines):
                self.numberOfLines = numberOfLines
            case .highlightedTextColor(let highlightedTextColor):
                self.highlightedTextColor = highlightedTextColor
            case .minimumScaleFactor(let minimumScaleFactor):
                self.minimumScaleFactor = minimumScaleFactor
            case .baselineAdjustment(let baselineAdjustment):
                self.baselineAdjustment = baselineAdjustment
            case .shadowColor(let shadowColor):
                self.shadowColor = shadowColor
            case .shadowOffset(let shadowOffset):
                self.shadowOffset = shadowOffset
            case .attributedText(let attributedText):
                self.attributedText = attributedText
            default:
                break
            }
        }
    }
}
