//
//  Array+Optional.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-18.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    var optional: Wrapped? { return self }
}

extension Sequence where Iterator.Element: OptionalType {
    func removeNils() -> [Iterator.Element.Wrapped] {
        return compactMap { $0.optional }
    }
}
