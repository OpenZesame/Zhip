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

public struct SignedTransaction {

    private let signature: String
    private let transaction: Transaction
    private let publicKeyCompressed: String

    init(transaction: Transaction, signedBy publicKey: PublicKey, signature: Signature) {
        self.transaction = transaction
        self.publicKeyCompressed = publicKey.hex.compressed
        self.signature = signature.asHexString()
    }
}

extension SignedTransaction: Encodable {

    enum CodingKeys: String, CodingKey {
        case version, toAddr, nonce, pubKey, amount, gasPrice, gasLimit, code, data, signature
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let tx = transaction
        let p = tx.payment

        try container.encode(tx.version, forKey: .version)
        try container.encode(p.nonce.nonce, forKey: .nonce)
        try container.encode(p.recipient.checksummed.hexString.value, forKey: .toAddr)
        try container.encode(publicKeyCompressed, forKey: .pubKey)

        try container.encode(p.amount, forKey: .amount)
        try container.encode(p.gasPrice, forKey: .gasPrice)


        try container.encode(p.gasLimit.description, forKey: .gasLimit)
        try container.encode(tx.code, forKey: .code)
        try container.encode(tx.data, forKey: .data)
        try container.encode(signature, forKey: .signature)
    }
}
