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
import BigInt

/// A type representing an Zilliqa amount in any denominator, specified by the `Unit` and the value measured
/// in said unit by the `Magnitude`. For convenience any type can be converted to the default units, such as
/// Zil, Li, and Qa. Any type can also be initialized from said units. For convenience we can perform arthimetic
// between two instances of the same type but we can also perform artithmetic between two different types, e.g.
// Zil(2) + Li(3_000_000) // 5 Zil
/// We can also compare them of course. An extension on The Magnitude allows for syntax like 3.zil
/// analogously for Li and Qa.
public protocol ExpressibleByAmount:
Codable,
Comparable,
CustomDebugStringConvertible,
ExpressibleByIntegerLiteral,
ExpressibleByFloatLiteral,
ExpressibleByStringLiteral
where Magnitude == BigInt {

    associatedtype Magnitude

    // These are the two most important properties of the `ExpressibleByAmount` protocol,
    // the unit in which the value - the magnitude is measured.
    static var unit: Unit { get }
    var qa: Magnitude { get }

    // "Designated" initializer
    init(valid: Magnitude)

    // Convenience translations
    var asLi: Li { get }
    var asZil: Zil { get }
    var asQa: Qa { get }

    static func validate(value: Magnitude) throws -> Magnitude
    
    // Convenience initializers
    init(trimming: String) throws
    init<E>(_ other: E) throws where E: ExpressibleByAmount
    init(zil: Zil) throws
    init(li: Li) throws
    init(qa: Qa) throws
    init(zil: String) throws
    init(li: String) throws
    init(qa: String) throws
}

public extension ExpressibleByAmount {
    var unit: Unit { return Self.unit }

    static var powerOf: String {
        return unit.powerOf
    }
}
