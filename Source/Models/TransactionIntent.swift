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
