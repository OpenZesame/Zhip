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

public protocol Bound {
    associatedtype Magnitude: Comparable & Numeric

    // "Designated" init, check bounds
    init(qa: Magnitude) throws

    /// Most important "convenience" init
    init(_ value: Magnitude) throws

    /// Various convenience inits
    init(_ doubleValue: Double) throws
    init(_ intValue: Int) throws
    init(_ stringValue: String) throws
    init<E>(_ other: E) throws where E: ExpressibleByAmount
    init(zil: Zil) throws
    init(li: Li) throws
    init(qa: Qa) throws
    init(zil: String) throws
    init(li: String) throws
    init(qa: String) throws
}

public extension ExpressibleByAmount where Self: Bound {
    /// Most important "convenience" init
    init(_ value: Magnitude) throws {
        try self.init(qa: Self.toQa(magnitude: value))
    }

    init(valid: Magnitude) {
        do {
            try self.init(valid)
        } catch {
            fatalError("The value `valid` (`\(valid)`) passed was invalid, error: \(error)")
        }
    }
}

public extension ExpressibleByAmount where Self: Bound {

    init(_ doubleValue: Double) throws {
        try self.init(qa: Self.toQa(double: doubleValue))
    }

    init(_ intValue: Int) throws {
        try self.init(Magnitude(intValue))
    }

    init(_ untrimmed: String) throws {
        let whiteSpacesRemoved = untrimmed.replacingOccurrences(of: " ", with: "")
        if let value = Magnitude(decimalString: whiteSpacesRemoved) {
           try self.init(try Self.validate(value: value))
        } else if let double = Double(whiteSpacesRemoved) {
            try self.init(double)
        } else {
            throw AmountError<Self>.nonNumericString
        }
    }
}

public extension ExpressibleByAmount where Self: Bound {
    init<E>(_ other: E) throws where E: ExpressibleByAmount {
        try self.init(qa: other.qa)
    }

    init(zil: Zil) throws {
        try self.init(zil)
    }

    init(li: Li) throws {
        try self.init(li)
    }

    init(qa: Qa) throws {
        try self.init(qa)
    }
}

public extension ExpressibleByAmount where Self: Bound {
    init(zil zilString: String) throws {
        try self.init(zil: try Zil(zilString))
    }

    init(li liString: String) throws {
        try self.init(li: try Li(liString))
    }

    init(qa qaString: String) throws {
        try self.init(qa: try Qa(qaString))
    }
}

// MARK: - ExpressibleByFloatLiteral
public extension ExpressibleByAmount where Self: Bound {
    init(floatLiteral double: Double) {
        do {
            try self.init(double)
        } catch {
            fatalError("The `Double` value (`\(double)`) passed was invalid, error: \(error)")
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral
public extension ExpressibleByAmount where Self: Bound {
    init(integerLiteral int: Int) {
        do {
            try self.init(int)
        } catch {
            fatalError("The `Int` value (`\(int)`) passed was invalid, error: \(error)")
        }
    }
}

// MARK: - ExpressibleByStringLiteral
public extension ExpressibleByAmount where Self: Bound {
    init(stringLiteral string: String) {
        do {
            try self = Self(string)
        } catch {
            fatalError("The `String` value (`\(string)`) passed was invalid, error: \(error)")
        }
    }
}


public extension Bound where Self: AdjustableLowerbound, Self: AdjustableUpperbound {
    static func restoreDefaultBounds() {
        restoreDefaultMin()
        restoreDefaultMax()
    }
}
