//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

public extension ExpressibleByAmount where Self: Bound {
    private static func qaFrom(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) throws -> Self {
        return try Self.init(qa: calc(lhs.qa, rhs.qa))
    }

    static func + (lhs: Self, rhs: Self) throws -> Self {
        return try qaFrom(lhs, rhs) { $0 + $1 }
    }

    static func * (lhs: Self, rhs: Self) throws -> Self {
        return try qaFrom(lhs, rhs) { $0 * $1 }
    }

    static func - (lhs: Self, rhs: Self) throws -> Self {
        return try qaFrom(lhs, rhs) { $0 - $1 }
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    static func - (lhs: Self, rhs: Self) -> Self {
        return qaFrom(lhs, rhs) { $0 - $1 }
    }

    private static func qaFrom(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) -> Self {
        return Self.init(qa: calc(lhs.qa, rhs.qa))
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return Self.init(qa: lhs.qa + rhs.qa)
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        return Self.init(qa: lhs.qa * rhs.qa)
    }
}

public func + <A, B>(lhs: A, rhs: B) throws -> A where A: ExpressibleByAmount & Bound, B: ExpressibleByAmount {
    return try A(qa: lhs.qa + rhs.qa)
}

public func + <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount & Unbound, B: ExpressibleByAmount {
    return A(qa: lhs.qa + rhs.qa)
}

public func - <A, B>(lhs: A, rhs: B) throws -> A where A: ExpressibleByAmount & Bound, B: ExpressibleByAmount {
    return try A(qa: lhs.qa - rhs.qa)
}

public func - <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount & Unbound, B: ExpressibleByAmount {
    return A(qa: lhs.qa - rhs.qa)
}
