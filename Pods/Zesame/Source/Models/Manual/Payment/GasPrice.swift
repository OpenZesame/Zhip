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
