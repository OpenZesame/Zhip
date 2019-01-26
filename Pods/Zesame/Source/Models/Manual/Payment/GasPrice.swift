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

public struct GasPrice: ExpressibleByAmount, AdjustableUpperbound, AdjustableLowerbound {

    public typealias Magnitude = Qa.Magnitude
    public static let unit: Unit = .qa

    public let qa: Magnitude

    /// By default GasPrice has a lowerobund of 1000 Li, i.e 1 000 000 000 Qa, this can be changed.
    public static let minInQaDefault: Magnitude = 1_000_000_000
    public static var minInQa = minInQaDefault {
        willSet {
            guard newValue <= maxInQa else {
                fatalError("Cannot set minInQa to greater than maxInQa, max: \(maxInQa), new min: \(newValue) (old: \(minInQa)")
            }
        }
    }

    /// By default GasPrice has an upperbound of 10 Zil, this can be changed.
    public static let maxInQaDefault: Magnitude = 10_000_000_000_000
    public static var maxInQa = maxInQaDefault {
        willSet {
            guard newValue >= minInQa else {
                fatalError("Cannot set maxInQa to less than minInQa, min: \(minInQa), new max: \(newValue) (old: \(maxInQa)")
            }
        }
    }

    public init(qa: Magnitude) throws {
        self.qa = try GasPrice.validate(value: qa)
    }
}
