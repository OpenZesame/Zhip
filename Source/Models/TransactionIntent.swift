//
//  Transaction.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct TransactionIntent: Codable {
    let amount: ZilAmount
    let recipient: AddressChecksummed

    init(amount: ZilAmount, to recipient: AddressChecksummedConvertible) {
        self.amount = amount
        self.recipient = recipient.checksummedAddress
    }
}

extension TransactionIntent {
    init?(amount amountString: String, to addresssHex: String) {
        guard
            let amount = try? ZilAmount(qa: amountString),
            let recipient = try? AddressChecksummed(string: addresssHex)
            else { return nil }
        self.init(amount: amount, to: recipient)
    }

    init?(queryParameters params: [URLQueryItem]) {
        guard let amount = params.first(where: { $0.name == TransactionIntent.CodingKeys.amount.stringValue })?.value,

            let hexAddress = params.first(where: { $0.name == TransactionIntent.CodingKeys.recipient.stringValue })?.value

            else {
                return nil
        }
        self.init(amount: amount, to: hexAddress)
    }
}
