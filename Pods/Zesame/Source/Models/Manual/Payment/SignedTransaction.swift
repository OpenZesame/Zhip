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
        let addressChecksummed = try p.recipient.toChecksummedLegacyAddress()
        try container.encode(addressChecksummed.hexString.value, forKey: .toAddr)
        try container.encode(publicKeyCompressed, forKey: .pubKey)

        try container.encode(p.amount, forKey: .amount)
        try container.encode(p.gasPrice, forKey: .gasPrice)


        try container.encode(p.gasLimit.description, forKey: .gasLimit)
        try container.encode(tx.code, forKey: .code)
        try container.encode(tx.data, forKey: .data)
        try container.encode(signature, forKey: .signature)
    }
}
