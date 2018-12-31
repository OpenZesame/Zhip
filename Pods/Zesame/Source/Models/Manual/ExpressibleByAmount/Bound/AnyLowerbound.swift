//
//  AnyLowerbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct AnyLowerbound {
    private let _withinBounds: (Any) throws -> Void
    init<L>(_ type: L.Type) where L: ExpressibleByAmount & Lowerbound {
        self._withinBounds = {
            guard let value = $0 as? L.Magnitude else {
                fatalError("incorrect implementation")
            }
            guard value >= L.minMagnitude else {
                throw AmountError<L>.tooSmall(min: L.min)
            }
            // Yes is within bounds
            return
        }
    }

    init<E>(_ type: E.Type) where E: ExpressibleByAmount & NoLowerbound {
        self._withinBounds = { ignoredValue in
            // no lower bound, do not throw, just return
            return
        }
    }

    public func throwErrorIfNotWithinBounds(_ value: Any) throws {
        return try _withinBounds(value)
    }
}
