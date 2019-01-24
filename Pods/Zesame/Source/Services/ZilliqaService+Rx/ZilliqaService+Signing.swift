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

import EllipticCurveKit
import Result

public extension ZilliqaService {

    func sendTransaction(for payment: Payment, keystore: Keystore, password: String, network: Network, done: @escaping Done<TransactionResponse>) {
        keystore.toKeypair(encryptedBy: password) {
            guard case .success(let keyPair) = $0 else { done(Result.failure($0.error!)); return }
            self.sendTransaction(for: payment, signWith: keyPair, network: network, done: done)
        }
    }

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair, network: Network, done: @escaping Done<TransactionResponse>) {
        let transaction = sign(payment: payment, using: keyPair, network: network)
        send(transaction: transaction, done: done)
    }

    func sign(payment: Payment, using keyPair: KeyPair, network: Network) -> SignedTransaction {

        let transaction = Transaction(payment: payment, version: Version(network: network))

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
