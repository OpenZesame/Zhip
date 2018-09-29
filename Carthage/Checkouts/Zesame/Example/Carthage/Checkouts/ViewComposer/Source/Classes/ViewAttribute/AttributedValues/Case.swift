//
//  Case.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public enum Case {
    case lowerCaseAll
    case upperCaseAll
    case upperCaseFirst
    case lowerCaseFirst
}

public extension Case {
    func apply(to text: String?) -> String? {
        guard let text = text else { return nil }
        return translated(from: text)
    }
}

public extension Case {
    func translated(from text: String) -> String {
        switch self {
        case .lowerCaseAll:
            return text.lowercased()
        case .upperCaseAll:
            return text.uppercased()
        case .upperCaseFirst:
            return text.upperCasingFirstLetter()
        case .lowerCaseFirst:
            return text.lowerCasingFirstLetter()
        }
    }
}

public extension String {
    func upperCasingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func upperCaseFirstLetter() {
        self = self.upperCasingFirstLetter()
    }
    
    func lowerCasingFirstLetter() -> String {
        let first = String(prefix(1)).lowercased()
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func lowerCaseFirstLetter() {
        self = self.lowerCasingFirstLetter()
    }
}
