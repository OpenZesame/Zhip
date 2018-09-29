//
//  MessageFromUnsignedTransaction.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import EllipticCurveKit

func messageFromUnsignedTransaction(_ tx: UnsignedTransaction, publicKey: PublicKey, hasher: EllipticCurveKit.Hasher = DefaultHasher.sha256) -> Message {
    let codeHex = formatCodeOrData(from: tx.code)
    let dataHex = formatCodeOrData(from: tx.data)

    let hexString = [
        hex64I(tx.version),
        hex64I(tx.nonce),
        tx.to.case(.upper),
        publicKey.hex.compressed.case(.lower),
        hex64D(tx.amount).case(.lower),
        hex64D(tx.gasPrice),
        hex64D(tx.gasLimit),
        eightChar(from: tx.code.count),
        codeHex,
        eightChar(from: tx.data.count),
        dataHex,
        ].joined()
    return Message(hashedHex: hexString, hashedBy: hasher)!
}

extension String {
    enum Case {
        case lower, upper
    }
    func `case`(_ `case`: Case) -> String {
        switch `case` {
        case .lower: return lowercased()
        case .upper: return uppercased()
        }
    }
}

private func hex64B(_ number: BigNumber) -> String {
    let hex = number.asHexStringLength64()
    assert(hex.count == 64)
    return hex
}

private func hex64D(_ number: Double) -> String {
    return hex64B(BigNumber(number))
}

private func hex64I(_ number: Int) -> String {
    return hex64D(Double(number))
}

private func eightChar(from int: Int) -> String {
    return String(format: "%08d", int)
}

private func formatCodeOrData(from string: String) -> String {
    if let data = string.data(using: .utf8) {
        return data.toHexString()
    } else {
        print("Failed to create Swift.Data from `code` or `data` having value: \n`\(string)`")
        return ""
    }
}
