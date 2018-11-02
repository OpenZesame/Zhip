//
//  Tracker.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol Tracking {
    func track(event: TrackableEvent)
}

protocol TrackableEvent {
    var eventName: String { get }
}

extension TrackableEvent where Self: RawRepresentable, Self.RawValue == String {
    var eventName: String {
        return rawValue
    }
}

protocol TrackedUserAction: TrackableEvent {}

struct Tracker: Tracking {
    func track(event: TrackableEvent) {
        print("🌍 tracked event: \(event.eventName)")
    }
}
