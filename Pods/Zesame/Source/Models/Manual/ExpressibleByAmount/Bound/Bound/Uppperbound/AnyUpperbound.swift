//
//  AnyUpperbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct AnyUpperbound {
    private let _withinBounds: (Any) throws -> Void
    init<L>(_ type: L.Type) where L: ExpressibleByAmount & Upperbound {
        self._withinBounds = {
            guard let value = $0 as? L.Magnitude else {
                fatalError("incorrect implementation")
            }
            guard value <= L.maxInQa else {
                throw AmountError<L>.tooLarge(max: L.max)
            }
            // Yes is within bounds
            return
        }
    }

    init<E>(_ type: E.Type) where E: ExpressibleByAmount & NoUpperbound {
        self._withinBounds = { ignoredValue in
            // no upper bound, do not throw, just return
            return
        }
    }

    public func throwErrorIfNotWithinBounds(_ value: Any) throws {
        return try _withinBounds(value)
    }
}
