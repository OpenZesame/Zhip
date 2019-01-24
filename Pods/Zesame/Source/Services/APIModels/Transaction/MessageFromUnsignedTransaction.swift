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

func messageFromUnsignedTransaction(_ tx: Transaction, publicKey: PublicKey, hasher: EllipticCurveKit.Hasher = DefaultHasher.sha256) -> Message {

    func formatCodeOrData(_ string: String) -> Data {
        return string.data(using: .utf8)!
    }

    let protoTransaction = ProtoTransactionCoreInfo.with {
        $0.version = tx.version.value
        $0.nonce = tx.payment.nonce.nonce
        $0.toaddr = Data(hex: tx.payment.recipient.asString.lowercased())
        $0.senderpubkey = publicKey.data.compressed.asByteArray
        $0.amount = tx.payment.amount.as16BytesLongArray
        $0.gasprice = tx.payment.gasPrice.as16BytesLongArray
        $0.gaslimit = UInt64(tx.payment.gasLimit)
        if let code = tx.code {
            $0.code = formatCodeOrData(code)
        }
        if let data = tx.data {
            $0.data = formatCodeOrData(data)
        }
    }

    return Message(hashedData: try! protoTransaction.serializedData(), hashedBy: hasher)
}

// MARK: - Private format helpers
private extension BigInt {
    /// Returns this integer as `Data` of `length`, if `length` is greater
    /// than the number itself, we pad empty bytes.
    func asData(minByteCount: Int? = nil) -> Data {
        var hexString = self.asHexString()
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

import BigInt
private extension ExpressibleByAmount {

    func asData(minByteCount: Int? = nil) -> Data {
        return qa.asData(minByteCount: minByteCount)
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
