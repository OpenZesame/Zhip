//
//  DeepLink.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum DeepLink {
    case send(Transaction)
}

extension DeepLink {
    var asTransaction: Transaction? {
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
            if let transaction = Transaction(queryParameters: params) {
                self = .send(transaction)
            } else {
                return nil
            }
        }
    }
}

import Zesame
private extension Transaction {
    init?(amount amountString: String, to addresssHex: String) {
        guard
            let amount = try? Amount(string: amountString),
            let recipient = try? Address(hexString: addresssHex)
            else { return nil }
        self.init(amount: amount, to: recipient)
    }

    init?(queryParameters params: [URLQueryItem]) {
        guard let amount = params.first(where: { $0.name == "amount" })?.value,

            let hexAddress = params.first(where: { $0.name == "recipient" })?.value

            else {
                return nil
        }
        self.init(amount: amount, to: hexAddress)
    }
}
