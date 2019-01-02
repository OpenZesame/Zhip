//
//  Tracking.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/// A type that can track events that are trackable
protocol Tracking {
    /// `context` should be made optional in your implementation, by using `NoContext`
    func track(event: TrackableEvent, context: Any)
    func track<S>(scene: S) where S: UIViewController
}

extension Tracking {
    func track<S>(scene: S) where S: UIViewController {
        guard Preferences.default.isTrue(.hasAcceptedAnalyticsTracking) else { return }
        let sceneName = "\(type(of: scene))"
        Firebase.Analytics.setScreenName(sceneName, screenClass: sceneName)
    }
}
