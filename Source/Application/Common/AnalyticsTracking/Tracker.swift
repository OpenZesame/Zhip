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

extension TrackableEvent {
    var eventName: String {
        if isEnum(type: self) {
            guard let nameOfEnumCase = nameOf(enumCase: self) else { fatalError("incorrect implementation") }
            return nameOfEnumCase
        } else {
            fatalError("You need to conform to `TrackableEvent`")
        }
    }
}

extension TrackableEvent where Self: RawRepresentable, Self.RawValue == String {
    var eventName: String {
        return rawValue
    }
}

protocol TrackedUserAction: TrackableEvent {}

struct Tracker: Tracking {

    private let preferences: Preferences

    init(preferences: Preferences = KeyValueStore(UserDefaults.standard)) {
        self.preferences = preferences
    }

    func track(event: TrackableEvent) {
        guard preferences.isTrue(.hasAcceptedAnalyticsTracking) else { return print("User did not accept analytics tracking, not sending 🌍 event: '\(event.eventName)'") }
        print("🌍 tracked event: \(event.eventName)")
    }
}

func nameOf(enumCase enumToMirror: Any) -> String? {
    guard isEnum(type: enumToMirror) else { return nil }
    let mirror = Mirror(reflecting: enumToMirror)
    if let enumCase = mirror.children.first {
        return enumCase.label ?? (enumCase.value as? String)
    } else {
        return String(describing: enumToMirror)
    }
}

func isEnum(type: Any) -> Bool {
    let mirror = Mirror(reflecting: type)
    guard
        let displayStyle = mirror.displayStyle,
        displayStyle == .enum
        else { return false }
    return true
}
