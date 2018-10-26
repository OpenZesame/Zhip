//
//  QRCoding.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import EFQRCode
import Zesame

final class QRCoding {}

extension QRCoding {
    struct Transaction: Codable {
        let amount: Double
        let recipient: Address

        init(amount: Amount, to recipient: Address) {
            self.amount = amount.amount
            self.recipient = recipient
        }
    }

    static func image(of transaction: Transaction, size: CGFloat) -> UIImage? {
        guard
            let transactionData = try? JSONEncoder().encode(transaction),
            let content = String(data: transactionData, encoding: .utf8)
            else { return nil }

        return generateImage(content: content, size: size)
    }

    static func transactionFrom(cgImage: CGImage) -> Transaction? {
        guard
            let scannedContentStrings = EFQRCode.recognize(image: cgImage),
            let scannedContentString = scannedContentStrings.first,
            let jsonData = scannedContentString.data(using: .utf8),
            let transaction = try? JSONDecoder().decode(Transaction.self, from: jsonData)
            else { return nil }
        return transaction
    }
}

private extension QRCoding {
    static func generateImage(content: String, size cgFloatSize: CGFloat, backgroundColor: UIColor = .zilliqaDarkBlue, foregroundColor: UIColor = .zilliqaCyan, watermark: CGImage? = nil) -> UIImage? {
        let intSize = Int(cgFloatSize)
        let size = EFIntSize(width: intSize, height: intSize)

        guard let cgImage = EFQRCode.generate(
            content: content,
            size: size,
            backgroundColor: backgroundColor.cgColor,
            foregroundColor: foregroundColor.cgColor,
            watermark: watermark) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
