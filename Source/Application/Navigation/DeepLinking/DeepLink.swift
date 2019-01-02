//
//  DeepLink.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
    
    static let scheme: String = "zupreme://"

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
