//
//  Transaction.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Transaction: Encodable {
//    public enum CodingKeys: String, CodingKey {
//        case publicKeyCompressed = "pubKey"
//
//        case to, amount, gasPrice, gasLimit, nonce, signature, version
//    }

    public let version: Int

    public let nonce: Int

    /// The public address of the recipient as a hex string
    /// E.g. "0xF510333720C5DD3C3C08BC8E085E8C981CE74691"
    public let to: String

    public let amount: Int

    public let pubKey: String

    public let gasPrice: Int

    public let gasLimit: Int

    public let code: String

    public let data: String

    public let signature: String

    public init(
        version: Int = 0,
        nonce: Int,
        to: String,
        amount: Int,
        publicKeyCompressed: String,
        gasPrice: Int,
        gasLimit: Int,
        code: String = "",
        data: String = "",
        signature: String
        ) {
        self.version = version
        self.nonce = nonce
        self.to = to.lowercased()
        self.amount = amount
        self.pubKey = publicKeyCompressed.lowercased()
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.code = code
        self.data = data
        self.signature = signature.lowercased()
    }

}

import EllipticCurveKit

public extension Transaction {
    init(unsignedTransaction tx: UnsignedTransaction, signedBy publicKey: PublicKey, signature: Signature) {
        self.init(
            version: tx.version,
            nonce: tx.nonce,
            to: tx.to,
            amount: Int(tx.amount),
            publicKeyCompressed: publicKey.data.compressed.toHexString(),
            gasPrice: Int(tx.gasPrice),
            gasLimit: Int(tx.gasLimit),
            signature: signature.asHexString()
        )
    }
}
