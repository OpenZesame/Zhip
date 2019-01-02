//
//  TrackedError.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum TrackedError {
    case failedToCreateUrl(from: String)
    case failedToSaveCodableOfType(String)
    case failedToMapSwiftErrorToType(String)
}

// Convenience
extension TrackedError {
    static func failedToSaveCodable<C: Codable>(type: C.Type) -> TrackedError {
        return .failedToSaveCodableOfType("\(type)")
    }

    static func failedToMapSwiftErrorTo<E: Error>(type: E.Type) -> TrackedError {
        return .failedToMapSwiftErrorToType("\(type)")
    }

}

extension TrackedError: TrackableEvent {
    var eventName: String {
        switch self {
        case .failedToCreateUrl(let urlString):
            return "failedToCreateUrl: \(urlString)"
        case .failedToSaveCodableOfType(let type):
            return "failedToSaveCodableOfType: \(type)"
        case .failedToMapSwiftErrorToType(let type):
            return "failedToMapSwiftErrorToType: \(type)"
        }
    }
}
