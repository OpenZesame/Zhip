//
//  Wallet+Codable.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Wallet: Encodable {
    public enum CodingKeys: String, CodingKey {
        case keystore, address
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keystore, forKey: .keystore)
        try container.encode(address, forKey: .address)
    }
}

extension Wallet: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.keystore = try container.decode(Keystore.self, forKey: .keystore)
        self.address = try container.decode(Address.self, forKey: .address)
    }
}
