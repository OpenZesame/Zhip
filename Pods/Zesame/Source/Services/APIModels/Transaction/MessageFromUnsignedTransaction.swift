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
        $0.toaddr = BigNumber(hexString: tx.payment.recipient.checksummedHex)!.asTrimmedData()
        $0.senderpubkey = publicKey.data.compressed.asByteArray
        $0.amount = tx.payment.amount.as16BytesLongArray
        $0.gasprice = tx.payment.gasPrice.as16BytesLongArray
        $0.gaslimit = UInt64(tx.payment.gasLimit.amount)
        $0.code = formatCodeOrData(tx.code)
        $0.data = formatCodeOrData(tx.data)
    }

    return Message(hashedData: try! protoTransaction.serializedData(), hashedBy: hasher)
}

// MARK: - Private format helpers
private extension Amount {

    var asBigNumber: BigNumber {
        return BigNumber(amount)
    }

    var asTrimmedData: Data {
        return asBigNumber.asTrimmedData()
    }

    var asByteArray: ByteArray {
        return asTrimmedData.asByteArray
    }

    var as16BytesLongArray: ByteArray {
        let data = asBigNumber.as16BytesLongData()
        return data.asByteArray
    }
}

private extension Data {
    var asByteArray: ByteArray {
        return ByteArray.with { $0.data = self }
    }
}

private extension BigNumber {
    func as16BytesLongData() -> Data {
        return Data(hex: String(asHexStringLength64().suffix(32)))
    }
}
