//
//  UIButton+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UIButton {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .contentEdgeInsets(let insets):
                self.contentEdgeInsets = insets
            case .titleEdgeInsets(let insets):
                self.titleEdgeInsets = insets
            case .reversesTitleShadowWhenHighlighted(let reverses):
                self.reversesTitleShadowWhenHighlighted = reverses
            case .imageEdgeInsets(let insets):
                self.imageEdgeInsets = insets
            case .adjustsImageWhenHighlighted(let adjusts):
                self.adjustsImageWhenHighlighted = adjusts
            case .adjustsImageWhenDisabled(let adjusts):
                self.adjustsImageWhenDisabled = adjusts
            case .showsTouchWhenHighlighted(let show):
                self.showsTouchWhenHighlighted = show
            case .states(let states):
                setControlStates(states)
            default:
                break
            }
        }
    }
}
