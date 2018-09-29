//
//  UIProgressView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

internal extension UIProgressView {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .progressViewStyle(let style):
                progressViewStyle = style
            case .progress(let progress):
                self.progress = progress
            case .progressTintColor(let color):
                progressTintColor = color
            case .progressImage(let image):
                progressImage = image
            case .trackTintColor(let color):
                trackTintColor = color
            case .trackImage(let image):
                trackImage = image
            default:
                break
            }
        }
    }
}

