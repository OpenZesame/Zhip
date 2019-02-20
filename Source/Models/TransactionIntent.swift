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
    let amount: ZilAmount

    init(amount: ZilAmount, to recipient: AddressChecksummedConvertible) {
        self.amount = amount
        self.to = recipient.checksummedAddress
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

            let hexAddress = params.first(where: { $0.name == TransactionIntent.CodingKeys.to.stringValue })?.value

            else {
                return nil
        }
        self.init(amount: amount, to: hexAddress)
    }

    var queryItems: [URLQueryItem] {
        return dictionaryRepresentation.compactMap {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }.sorted(by: { $0.name.count < $1.name.count })
    }
}
