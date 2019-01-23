//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import RxSwift
import RxCocoa

final class DeepLinkHandler {
    enum AnalyticsEvent: TrackableEvent {
        case handlingIncomingDeeplink
        case sourceOfDeepLink(sendingAppId: String)
        case failedToParseLink

        var eventName: String {
            switch self {
            case .handlingIncomingDeeplink: return "handlingIncomingDeeplink"
            case .sourceOfDeepLink(let sendingAppId): return "sourceOfDeepLink: \(sendingAppId)"
            case .failedToParseLink: return "failedToParseLink"
            }
        }
    }

    private let tracker: Tracker
    private let navigator: Navigator<DeepLink>

    /// This buffered link gets set when the app is locked with a PIN code
    private var bufferedLink: DeepLink?
    private var appIsLockedSoBufferLink = false

    init(tracker: Tracker = Tracker(), navigator: Navigator<DeepLink> = Navigator<DeepLink>()) {
        self.tracker = tracker
        self.navigator = navigator
    }

    func appIsLockedBufferDeeplinks() {
        appIsLockedSoBufferLink = true
    }
    func appIsUnlockedEmitBufferedDeeplinks() {
        defer { bufferedLink = nil }
        appIsLockedSoBufferLink = false
        guard let link = bufferedLink else { return }
        navigate(to: link)
    }
}

extension DeepLinkHandler {

    /// Read more: https://developer.apple.com/documentation/uikit/core_app/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app
    /// Handles incoming `url`, e.g. `Zhip://send?to=0x1a2b3c&amount=1337`
    ///
    /// return: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handle(url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        track(event: .handlingIncomingDeeplink)

        if let sendingAppID = options[.sourceApplication] as? String {
            track(event: .sourceOfDeepLink(sendingAppId: sendingAppID))
        }

        guard let destination = DeepLink(url: url) else {
            track(event: .failedToParseLink)
            return false
        }

        navigate(to: destination)
        return true
    }

    var navigation: Driver<DeepLink> {
        return navigator.navigation.filter { [unowned self] _ in return !self.appIsLockedSoBufferLink }
    }

}

// MARK: Private
private extension DeepLinkHandler {
    func navigate(to destination: DeepLink) {
        if appIsLockedSoBufferLink {
            bufferedLink = destination
        } else {
            navigator.next(destination)
        }
    }

    func track(event: AnalyticsEvent) {
        tracker.track(event: event)
    }
}

