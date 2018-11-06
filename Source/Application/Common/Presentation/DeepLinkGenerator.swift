//
//  DeepLinkGenerator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class DeepLinkGenerator {
    private let tracker: Tracker
    init(tracker: Tracker = Tracker()) {
        self.tracker = tracker
    }
}

extension DeepLinkGenerator {
    func linkTo(transaction: Transaction) -> URL {
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
        print("share url: \(shareUrl)")
        return shareUrl
    }
}
