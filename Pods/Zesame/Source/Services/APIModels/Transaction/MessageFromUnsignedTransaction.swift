//
//  MessageFromUnsignedTransaction.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import EllipticCurveKit

func messageFromUnsignedTransaction(_ tx: Transaction, publicKey: PublicKey, hasher: EllipticCurveKit.Hasher = DefaultHasher.sha256) -> Message {

    func formatCodeOrData(_ string: String) -> Data {
        return string.data(using: .utf8)!
    }

    let protoTransaction = ProtoTransactionCoreInfo.with {
        $0.version = tx.version
        $0.nonce = tx.payment.nonce.nonce
        $0.toaddr = Data(hex: tx.payment.recipient.checksummedHex)
        $0.senderpubkey = publicKey.data.compressed.asByteArray
        $0.amount = tx.payment.amount.as16BytesLongArray
        $0.gasprice = tx.payment.gasPrice.as16BytesLongArray
        $0.gaslimit = UInt64(tx.payment.gasLimit.valueForTransaction)
        $0.code = formatCodeOrData(tx.code)
        $0.data = formatCodeOrData(tx.data)
    }

    return Message(hashedData: try! protoTransaction.serializedData(), hashedBy: hasher)
}

// MARK: - Private format helpers
private extension Int {
    /// Returns this integer as `Data` of `length`, if `length` is greater
    /// than the number itself, we pad empty bytes.
    func asData(minByteCount: Int? = nil) -> Data {
        var hexString = String(self, radix: 16)
        if let minByteCount = minByteCount {
            // each byte is represented as two hexadecimal chars
            let minStringLength = 2 * minByteCount
            while hexString.count < minStringLength {
                hexString = "0" + hexString
            }
        }
        return Data(hex: hexString)
    }
}

private extension ExpressibleByAmount {

    func asData(minByteCount: Int? = nil) -> Data {
        return valueForTransaction.asData(minByteCount: minByteCount)
    }

    var asByteArray: ByteArray {
        return asData().asByteArray
    }

    var as16BytesLongArray: ByteArray {
        return asData(minByteCount: 16).asByteArray
    }
}

private extension Data {
    var asByteArray: ByteArray {
        return ByteArray.with { $0.data = self }
    }
}
