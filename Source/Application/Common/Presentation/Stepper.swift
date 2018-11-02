//
//  Stepper.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class Stepper<Step> {

    private let navigationSubject: PublishSubject<Step>
    private let tracker: Tracking

    init(navigationSubject: PublishSubject<Step> = PublishSubject<Step>(), tracker: Tracking = Tracker()) {
        self.navigationSubject = navigationSubject
        self.tracker = tracker
    }
}

extension Stepper {

    var navigationSteps: Driver<Step> {
        return navigationSubject.asDriverOnErrorReturnEmpty()
    }

    func step(_ step: Step) {
        navigationSubject.onNext(step)

        if let userAction = step as? TrackedUserAction {
            return track(event: userAction)
        }

        guard let userAction = findNestedEnumOfType(TrackedUserAction.self, in: step, recursiveTriesLeft: 3) else { return }

        track(event: userAction)
    }
}

func findNestedEnumOfType<Nested>(_ wantedType: Nested.Type, in parent: Any, recursiveTriesLeft: Int) -> Nested? {
    guard recursiveTriesLeft >= 0 else { return nil }

    guard
        case let mirror = Mirror(reflecting: parent),
        let displayStyle = mirror.displayStyle,
        displayStyle == .enum,
        let child = mirror.children.first
        else { return nil }

    guard let needle = child.value as? Nested
        else { return findNestedEnumOfType(wantedType, in: parent, recursiveTriesLeft: recursiveTriesLeft - 1) }

    return needle
}


extension Stepper: Tracking {
    func track(event: TrackableEvent) {
        tracker.track(event: event)
    }
}

struct Tracker: Tracking {
    func track(event: TrackableEvent) {
        print("🌍 tracked event: \(event.eventName)")
    }
}

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
