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

import Foundation
import Zesame

struct TransactionIntent: Codable {
    let to: AddressChecksummed
    let amount: ZilAmount?

    init(to recipient: AddressChecksummedConvertible, amount: ZilAmount? = nil) {
        self.to = recipient.checksummedAddress
        self.amount = amount
    }
}

extension TransactionIntent {
    static func fromScannedQrCodeString(_ scannedString: String) -> TransactionIntent? {
        if let adddress = try? AddressNotNecessarilyChecksummed(string: scannedString) {
            return TransactionIntent(to: adddress)
        } else {
            guard
                let json = scannedString.data(using: .utf8),
                let transaction = try? JSONDecoder().decode(TransactionIntent.self, from: json) else {
                    return nil
            }
            return transaction
        }
    }
}

extension TransactionIntent {
    init?(to addresssHex: String, amount: String?) {
        guard let recipient = try? AddressChecksummed(string: addresssHex) else { return nil }
        self.init(to: recipient, amount: ZilAmount.fromQa(optionalString: amount))
    }

    init?(queryParameters params: [URLQueryItem]) {
        guard let hexAddress = params.first(where: { $0.name == TransactionIntent.CodingKeys.to.stringValue })?.value else {
            return nil
        }
        let amount = params.first(where: { $0.name == TransactionIntent.CodingKeys.amount.stringValue })?.value
        self.init(to: hexAddress, amount: amount)
    }

    var queryItems: [URLQueryItem] {
        return dictionaryRepresentation.compactMap {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }.sorted(by: { $0.name.count < $1.name.count })
    }
}

private extension ZilAmount {
    static func fromQa(optionalString: String?) -> ZilAmount? {
        guard let qaAmountString = optionalString else { return nil }
        return try? ZilAmount(qa: qaAmountString)
    }
}
