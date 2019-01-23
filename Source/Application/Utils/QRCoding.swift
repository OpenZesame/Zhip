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
        foregroundColor: UIColor = .black,
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
