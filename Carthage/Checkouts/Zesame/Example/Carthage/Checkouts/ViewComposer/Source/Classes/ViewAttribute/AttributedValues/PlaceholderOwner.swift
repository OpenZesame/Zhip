//
//  PlaceholderOwner.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-01.
//
//

import Foundation

public protocol PlaceholderOwner: class {
    var placeholder: String? { get set }
}

internal extension PlaceholderOwner {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .placeholder(let placeholder):
                self.placeholder = placeholder
            default:
                break
            }
        }
    }
}

extension UITextField: PlaceholderOwner {}
extension UISearchBar: PlaceholderOwner {}
