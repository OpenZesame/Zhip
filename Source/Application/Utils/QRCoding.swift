//
//  QRCoding.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
