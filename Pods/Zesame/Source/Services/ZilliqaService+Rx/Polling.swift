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

public struct Polling {
    public let count: Count
    public let backoff: Backoff
    public let initialDelay: Delay
    
    public init(_ count: Count, backoff: Backoff, initialDelay: Delay) {
        self.count = count
        self.backoff = backoff
        self.initialDelay = initialDelay
    }
}

public extension Polling {
    static var twentyTimesLinearBackoff: Polling {
        return Polling(.twentyTimes,
                       backoff: .linearIncrement(of: .twoSeconds),
                       initialDelay: .oneSecond
        )
    }
    
    public enum Backoff {
        case linearIncrement(of: Delay)
    }
    
    public enum Delay: Int {
        case oneSecond = 1
        case twoSeconds = 2
        case threeSeconds = 3
        case fiveSeconds = 5
        case sevenSeconds = 7
        case tenSeconds = 10
        case twentySeconds = 20
    }
    
    public enum Count: Int {
        case once = 1
        case twice = 2
        case threeTimes = 3
        case fiveTimes = 5
        case tenTimes = 10
        case twentyTimes = 20
    }
}

extension Polling.Backoff {
    func add(to delayInSeconds: Int) -> Int {
        switch self {
        case .linearIncrement(let delayIncrement):
            return delayInSeconds + delayIncrement.rawValue
        }
    }
}
