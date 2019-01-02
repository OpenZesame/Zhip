//
//  TrackableEvent.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Trackable event, most likely user interaction, i.e, button tap.
protocol TrackableEvent {
    var eventName: String { get }
    var eventContext: String { get }
}

extension TrackableEvent where Self: RawRepresentable, Self.RawValue == String {
    var eventName: String {
        return rawValue
    }
}

// MARK: Default Implemtation for `enum` that do not have RawTypes, using reflection
extension TrackableEvent {
    var eventContext: String {
        return String(describing: type(of: self))
    }
}

