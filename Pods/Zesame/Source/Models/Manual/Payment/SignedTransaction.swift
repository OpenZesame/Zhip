//
//  SignedTransaction.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
        try container.encode(p.recipient, forKey: .toAddr)
        try container.encode(publicKeyCompressed, forKey: .pubKey)

        try zip(
            [p.amount.encodableValue, p.gasPrice.encodableValue],
            [CodingKeys.amount, CodingKeys.gasPrice]
        ).forEach {
            try container.encode($0, forKey: $1)
        }

        try container.encode(p.gasLimit.description, forKey: .gasLimit)
        try container.encode(tx.code, forKey: .code)
        try container.encode(tx.data, forKey: .data)
        try container.encode(signature, forKey: .signature)
    }
}

extension ExpressibleByAmount {

    // The API expects integer representation of the magnitude, so e.g.
    // `100` for GasPrice.
    var valueForTransaction: Int {
        return Int(inQa.magnitude)
    }
}

private extension ExpressibleByAmount {
    var encodableValue: String {
        // The API expects strings representation of integer values
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        precondition(!valueForTransaction.description.contains(decimalSeparator), "String should represent an integer")
        return valueForTransaction.description
    }
}
