//
//  FontSizeAdjusting.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-10.
//
//

import UIKit

public protocol FontSizeAdjusting: class {
    var adjustsFontSizeToFitWidth: Bool { get set }
}

extension UILabel: FontSizeAdjusting {}
extension UITextField: FontSizeAdjusting {}

internal extension FontSizeAdjusting {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .adjustsFontSizeToFitWidth(let adjustsFontSizeToFitWidth):
                self.adjustsFontSizeToFitWidth  = adjustsFontSizeToFitWidth
            default:
                break
            }
        }
    }
}
