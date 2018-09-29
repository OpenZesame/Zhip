//
//  UITextView+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UITextView {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .selectedRange(let range):
                selectedRange = range
            case .linkTextAttributes(let attributes):
                linkTextAttributes = attributes
            case .textContainerInset(let inset):
                textContainerInset = inset
            case .dataDetectorTypes(let types):
                self.dataDetectorTypes = types
            default:
                break
            }
        }
    }
}
