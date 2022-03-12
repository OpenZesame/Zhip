//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import Zesame

extension Address: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let addressString = try container.decode(String.self).lowercased()
        try self.init(string: addressString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.asString.uppercased())
    }
}


public struct TransactionIntent: Codable, Equatable {
    public let to: Address
    public let amount: ZilAmount?
    
    public init(to recipient: Address, amount: ZilAmount? = nil) {
        self.to = recipient
        self.amount = amount
    }
}

public extension TransactionIntent {
    static func fromScannedQrCodeString(_ scannedString: String) throws -> TransactionIntent {
        do {
            return TransactionIntent(to: try Address(string: scannedString))
        } catch {
            guard let json = scannedString.data(using: .utf8) else { throw Error.scannedStringNotAddressNorJson }
            return try JSONDecoder().decode(TransactionIntent.self, from: json)
        }
    }
    
    enum Error: Swift.Error, Equatable {
        case scannedStringNotAddressNorJson
    }
}

public extension TransactionIntent {
    init?(to recipientString: String, amount: String?) {
        guard let recipient = try? Address(string: recipientString) else { return nil }
        self.init(to: recipient, amount: ZilAmount.fromQa(optionalString: amount))
    }

    init?(queryParameters params: [URLQueryItem]) {
        guard let addressFromParam = params.first(where: { $0.name == TransactionIntent.CodingKeys.to.stringValue })?.value else {
            return nil
        }
        let amount = params.first(where: { $0.name == TransactionIntent.CodingKeys.amount.stringValue })?.value
        self.init(to: addressFromParam, amount: amount)
    }

    var queryItems: [URLQueryItem] {
        return dictionaryRepresentation.compactMap {
            URLQueryItem(name: $0.key, value: String(describing: $0.value).lowercased())
        }.sorted(by: { $0.name.count < $1.name.count })
    }
}

// MARK: - Codable
public extension TransactionIntent {
    enum CodingKeys: CodingKey {
        case to, amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        to = try container.decode(Address.self, forKey: .to)
        amount = try container.decodeIfPresent(ZilAmount.self, forKey: .amount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(to, forKey: .to)
        try container.encodeIfPresent(amount, forKey: .amount)
    }
}

private extension ZilAmount {
    static func fromQa(optionalString: String?) -> ZilAmount? {
        guard let qaAmountString = optionalString else { return nil }
        return try? ZilAmount(qa: qaAmountString)
    }
}


public extension Encodable {
	var dictionaryRepresentation: [String: Any] {
		let jsonEncoder = JSONEncoder()
		do {
			let data = try jsonEncoder.encode(self)
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
			return jsonObject ?? [:]
		} catch {
			return [:]
		}
	}
}
