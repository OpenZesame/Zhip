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

enum DeepLink {
    case send(TransactionIntent)
}

extension DeepLink {
    var asTransaction: TransactionIntent? {
        switch self {
        case .send(let transaction): return transaction
        }
    }
}

extension DeepLink {
    
    static let scheme: String = "zhip://"

    enum Path: String, CaseIterable {
        case send
    }
}

extension DeepLink {
    enum ParseError: Swift.Error {
        case failedToParse
    }

    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let urlHost = components.host,
            let params = components.queryItems,
            let deepLinkPath = DeepLink.Path(rawValue: urlHost)
            else {
                return nil
        }

        switch deepLinkPath {
        case .send:
            if let transaction = TransactionIntent(queryParameters: params) {
                self = .send(transaction)
            } else {
                return nil
            }
        }
    }
}
