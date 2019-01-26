// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
