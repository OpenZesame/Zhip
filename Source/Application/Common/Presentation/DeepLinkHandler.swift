//
//  DeepLinkHandler.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-05.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class DeepLinkHandler {
    enum AnalyticsEvent: TrackableEvent {
        case receivedLinkFrom
        case sourceOfDeepLink(sendingAppId: String)
        case failedToParseLink
    }

    private let tracker: Tracker
    private var stepper: Stepper<DeepLink>?

    init(tracker: Tracker = Tracker()) {
        self.tracker = tracker
    }
}

extension DeepLinkHandler {

    func set(stepper: Stepper<DeepLink>) {
        self.stepper = stepper
    }

    /// Read more: https://developer.apple.com/documentation/uikit/core_app/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app
    /// Handles incoming `url`, e.g. `zupreme://send?to=0x1a2b3c&amount=1337`
    ///
    /// return: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handle(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        track(event: .receivedLinkFrom)

        if let sendingAppID = options[.sourceApplication] as? String {
            track(event: .sourceOfDeepLink(sendingAppId: sendingAppID))
        }

        guard let destination = DeepLink(url: url) else {
            log.error("Unable to create destination from url: \(url)")
            return false
        }

        navigate(to: destination)
        return true
    }
}

// MARK: Private
private extension DeepLinkHandler {
    func navigate(to destination: DeepLink) {
        guard let stepper = stepper else { return log.error("Unable to step, no stepper") }
        stepper.step(destination)
    }

    func track(event: AnalyticsEvent) {
        tracker.track(event: event)
    }
}

