//
//  ZilliqaService+Signing.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import EllipticCurveKit
import Result

public extension ZilliqaService {

    func sendTransaction(for payment: Payment, keystore: Keystore, passphrase: String, done: @escaping Done<TransactionResponse>) {
        keystore.toKeypair(encryptedBy: passphrase) {
            guard case .success(let keyPair) = $0 else { done(Result.failure($0.error!)); return }
            self.sendTransaction(for: payment, signWith: keyPair, done: done)
        }
    }

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair, done: @escaping Done<TransactionResponse>) {
        let transaction = sign(payment: payment, using: keyPair)
        send(transaction: transaction, done: done)
    }

    func sign(payment: Payment, using keyPair: KeyPair) -> SignedTransaction {

        let transaction = Transaction(payment: payment)

        let message = messageFromUnsignedTransaction(transaction, publicKey: keyPair.publicKey)

        let signature = sign(message: message, using: keyPair)

        assert(Signer.verify(message, wasSignedBy: signature, publicKey: keyPair.publicKey))

        return SignedTransaction(transaction: transaction, signedBy: keyPair.publicKey, signature: signature)
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
