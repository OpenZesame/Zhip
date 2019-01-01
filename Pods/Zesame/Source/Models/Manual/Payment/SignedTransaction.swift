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

        try container.encode(p.amount, forKey: .amount)
        try container.encode(p.gasPrice, forKey: .gasPrice)


        try container.encode(p.gasLimit.description, forKey: .gasLimit)
        try container.encode(tx.code, forKey: .code)
        try container.encode(tx.data, forKey: .data)
        try container.encode(signature, forKey: .signature)
    }
}
