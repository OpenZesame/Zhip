//
//  UISwitch+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UISwitch {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .on(let isOn):
                self.isOn = isOn
            case .onTintColor(let color):
                self.onTintColor = color
            case .onImage(let image):
                self.onImage = image
            case .offImge(let image):
                self.offImage = image
            default:
                break
            }
        }
    }
}
