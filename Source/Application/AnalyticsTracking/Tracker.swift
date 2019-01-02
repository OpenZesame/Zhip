//
//  Tracker.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Firebase

/// Type that can track events and sending them to some third party network storage
struct Tracker {

    private let preferences: Preferences

    init(preferences: Preferences = .default) {
        self.preferences = preferences
    }
}

// MARK: - Tracking
struct NoContext {}
extension Tracker: Tracking {
    func track(event: TrackableEvent, context overridingContext: Any = NoContext()) {
        guard preferences.isTrue(.hasAcceptedAnalyticsTracking) else { return }

        let context: String
        if !(overridingContext is NoContext) {
            if let contextString = overridingContext as? CustomStringConvertible {
                context = contextString.description
            } else {
                context = "\(type(of: overridingContext))"
            }
        } else {
            context = event.eventContext
        }

        Firebase.Analytics.logEvent(event.eventName, parameters: [
            "Context": context
        ])
    }
}
