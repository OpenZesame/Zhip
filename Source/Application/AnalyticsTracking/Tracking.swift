//
//  Tracking.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// A type that can track events that are trackable
protocol Tracking {
    /// `context` should be made optional in your implementation, by using `NoContext`
    func track(event: TrackableEvent, context: Any)
}
