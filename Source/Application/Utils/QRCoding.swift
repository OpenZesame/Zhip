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

import UIKit
import EFQRCode

private typealias Image = Asset

protocol QRCoding: AnyObject {
    func encode(transaction: TransactionIntent, size: CGFloat) -> UIImage?
    func decode(cgImage: CGImage) -> TransactionIntent?
}

/// A type capable of encoding and decoding Transaction to and from QR codes
final class QRCoder {}

extension QRCoder: QRCoding {

    func encode(transaction: TransactionIntent, size: CGFloat) -> UIImage? {
        guard
            let transactionData = try? JSONEncoder().encode(transaction),
            let content = String(data: transactionData, encoding: .utf8)
            else { return nil }

        return generateImage(content: content, size: size)
    }

    func decode(cgImage: CGImage) -> TransactionIntent? {
        guard
            let scannedContentStrings = EFQRCode.recognize(image: cgImage),
            let scannedContentString = scannedContentStrings.first,
            let jsonData = scannedContentString.data(using: .utf8),
            let transaction = try? JSONDecoder().decode(TransactionIntent.self, from: jsonData)
            else { return nil }
        return transaction
    }
}

// MARK: - Private
private extension QRCoding {
    func generateImage(
        content: String,
        size cgFloatSize: CGFloat,
        backgroundColor: UIColor = .teal,
        foregroundColor: UIColor = .deepBlue,
        watermarkImage: UIImage? = nil
        ) -> UIImage? {
        let intSize = Int(cgFloatSize)
        let size = EFIntSize(width: intSize, height: intSize)

        guard let cgImage = EFQRCode.generate(
            content: content,
            size: size,
            backgroundColor: backgroundColor.cgColor,
            foregroundColor: foregroundColor.cgColor,
            watermark: watermarkImage?.cgImage) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
