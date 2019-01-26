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
