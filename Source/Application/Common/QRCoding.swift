//
//  QRCoding.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import EFQRCode

final class QRCoding {}

extension QRCoding {

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
    static func generateImage(content: String, size cgFloatSize: CGFloat, backgroundColor: UIColor = .white, foregroundColor: UIColor = .black, watermarkImage: UIImage? = UIImage(named: "zilliqa_logo")) -> UIImage? {
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
