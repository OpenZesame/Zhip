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

import Foundation

final class DeepLinkGenerator {
    private let tracker: Tracker
    init(tracker: Tracker = Tracker()) {
        self.tracker = tracker
    }
}

extension DeepLinkGenerator {
    func linkTo(transaction: TransactionIntent) -> URL {
        guard var urlComponents = URLComponents(string: DeepLink.scheme) else {
            incorrectImplementation("Should be possible to create deep links, control the scheme: '\(DeepLink.scheme)'")
        }
        urlComponents.host = "send"
        urlComponents.queryItems = transaction.dictionaryRepresentation.compactMap {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        guard let shareUrl = urlComponents.url else {
            incorrectImplementation("Should be possible to create share link for transaction: \(transaction), check implementation")
        }
        return shareUrl
    }
}
