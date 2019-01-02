//
//  OpenUrl.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

func openUrl(string baseUrlString: String, relative path: String? = nil, tracker: Tracker? = nil, context: Any = NoContext()) {
    func createUrl() -> URL? {
        guard let baseUrl = URL(string: baseUrlString) else { return nil }
        guard let path = path else { return baseUrl }
        return URL(string: path, relativeTo: baseUrl)
    }

    guard let url = createUrl() else {
        log.warning("Failed to create")
        tracker?.track(event: TrackedError.failedToCreateUrl(from: baseUrlString), context: context)
        return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
