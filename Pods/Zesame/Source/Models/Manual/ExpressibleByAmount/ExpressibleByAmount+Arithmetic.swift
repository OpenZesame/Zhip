// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
