//
//  Polling.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-11.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
