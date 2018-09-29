//
//  UISearchBar+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

extension UISearchBar: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UISearchBar {
        return UISearchBar(frame: .zero)
    }
}
