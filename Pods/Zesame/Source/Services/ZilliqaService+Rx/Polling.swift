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
