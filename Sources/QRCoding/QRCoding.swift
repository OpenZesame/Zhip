//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import EFQRCode
import SwiftUI
import TransactionIntent
import Styleguide
import Wallet
import enum Zesame.Address
import struct Zesame.Bech32Address
import struct Zesame.LegacyAddress


public protocol QRCoding: AnyObject {
    func encode(address: Address, size: CGFloat) -> Image?
    func encode(transaction: TransactionIntent, size: CGFloat) -> Image?
    func decode(cgImage: CGImage) -> TransactionIntent?
}

public extension QRCoding {
    func encode(
        address: Address,
        size: CGFloat? = nil
    ) -> Image? {
        encode(address: address, size: size ?? 200)
    }
    
    func encode(
        bech32Address: Bech32Address,
        size: CGFloat? = nil
    ) -> Image? {
        encode(address: .bech32(bech32Address), size: size)
    }
    
    func encode(
        legacyAddress: LegacyAddress,
        size: CGFloat? = nil
    ) -> Image? {
        encode(address: .legacy(legacyAddress), size: size)
    }
    
    func encodeAddress(
        of wallet: Wallet,
        size: CGFloat? = nil
    ) -> Image? {
		let legacyAddress = try! LegacyAddress(string: wallet.address(.legacy))
		return encode(legacyAddress: legacyAddress, size: size)
    }
}

/// A type capable of encoding and decoding Transaction to and from QR codes
public final class QRCoder: QRCoding {
    
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    public init(
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init()
    ) {
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
}

public extension QRCoder {
    
    func encode(address: Address, size: CGFloat) -> Image? {
        return generateImage(content: address.asString, size: size)
    }

    func encode(transaction: TransactionIntent, size: CGFloat) -> Image? {
        guard
            let transactionData = try? jsonEncoder.encode(transaction),
            let content = String(data: transactionData, encoding: .utf8)
            else { return nil }

        return generateImage(content: content, size: size)
    }

    func decode(cgImage: CGImage) -> TransactionIntent? {
        let scannedContentStrings = EFQRCode.recognize(cgImage)
        guard
            let scannedContentString = scannedContentStrings.first,
            let jsonData = scannedContentString.data(using: .utf8),
            let transaction = try? jsonDecoder.decode(TransactionIntent.self, from: jsonData)
            else { return nil }
        return transaction
    }
}

// MARK: - Private
private extension QRCoding {
    func generateImage(
        content: String,
        size cgFloatSize: CGFloat,
        backgroundColor: Color = .turquoise,
        foregroundColor: Color = .deepBlue
        //        watermarkImage: Image? = nil
    ) -> Image? {
        
        let intSize = Int(cgFloatSize)
        let size = EFIntSize(width: intSize, height: intSize)
        
        guard
            let backgroundCGColor = backgroundColor.cgColor,
            let foregroundCGColor = foregroundColor.cgColor,
            
            let cgImage = EFQRCode.generate(
                for: content,
                size: size,
                backgroundColor: backgroundCGColor,
                foregroundColor: foregroundCGColor
                //            watermark: watermarkImage?.cgImage
            )
        else {
            return nil
        }
        
        return Image(decorative: cgImage, scale: 1.0)
    }
}
