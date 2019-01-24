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

public struct ZilAmount: ExpressibleByAmount, Upperbound, Lowerbound {

    public typealias Magnitude = Zil.Magnitude

    public static let unit: Unit = .zil

    public static let minInQa: Zil.Magnitude = 0
    public static let maxInQa: Zil.Magnitude = "21000000000000000000000"

    public let qa: Magnitude

    public init(qa: Magnitude) throws {
         self.qa = try ZilAmount.validate(value: qa)
    }
}
