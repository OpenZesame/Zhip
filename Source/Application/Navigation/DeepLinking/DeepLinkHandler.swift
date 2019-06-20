// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import RxSwift
import RxCocoa

final class DeepLinkHandler {

    private let navigator: Navigator<DeepLink>

    /// This buffered link gets set when the app is locked with a PIN code
    private var bufferedLink: DeepLink?
    private var appIsLockedSoBufferLink = false

    init(navigator: Navigator<DeepLink> = Navigator<DeepLink>()) {
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

    /// Read more: https://developer.apple.com/documentation/uikit/core_app/allowing_apps_and_websites_to_link_to_your_content/handling_universal_links
    /// Handles universal link `url`, e.g. `https://zhip.app/send?to=0x1a2b3c&amount=1337`
    ///
    /// return: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handle(url: URL) -> Bool {
        guard let destination = DeepLink(url: url) else {
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
}

