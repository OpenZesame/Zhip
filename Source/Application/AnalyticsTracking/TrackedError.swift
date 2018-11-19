//
//  TrackedError.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum TrackedError: TrackableEvent {

    case failedToCreateUrl(from: String)

    var eventName: String {
        switch self {
        case .failedToCreateUrl(let urlString):
            return "failed to create url from: \(urlString)"
        }
    }
}
