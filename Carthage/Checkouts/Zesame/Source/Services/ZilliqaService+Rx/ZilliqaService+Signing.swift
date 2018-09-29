//
//  ZilliqaService+Signing.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import EllipticCurveKit

public extension ZilliqaService {

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair, done: @escaping Done<TransactionIdentifier>) {
        let transaction = sign(payment: payment, using: keyPair)
        send(transaction: transaction, done: done)
    }

    func sign(payment: Payment, using keyPair: KeyPair) -> Transaction {

        let unsignedTransaction = UnsignedTransaction(payment: payment)

        let message = messageFromUnsignedTransaction(unsignedTransaction, publicKey: keyPair.publicKey)

        let signature = sign(message: message, using: keyPair)

        assert(Signer.verify(message, wasSignedBy: signature, publicKey: keyPair.publicKey))

        return Transaction(unsignedTransaction: unsignedTransaction, signedBy: keyPair.publicKey, signature: signature)
    }

    func sign(message: Message, using keyPair: KeyPair) -> Signature {
        return Signer.sign(message, using: keyPair, personalizationDRBG: drbgPers)
    }
}

private let drbgPers: Data = {
    let pers = "Schnorr+SHA256  ".data(using: .ascii)!
    var returnValue = Data([Byte](repeating: 0x00, count: 32))
    returnValue = returnValue + pers
    if returnValue.count != 48 { fatalError("bad length") }
    return returnValue
}()
