//
//  UISearchBar+ViewStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-15.
//
//

import Foundation

internal extension UISearchBar {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .prompt(let prompt):
                self.prompt = prompt
            case .searchBarStyle(let style):
                self.searchBarStyle = style
            default:
                break
            }
        }
    }
}
