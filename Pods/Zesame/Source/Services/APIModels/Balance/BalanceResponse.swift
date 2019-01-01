//
//  BalanceResponse.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// Encodable for test purposes, this type is never sent TO the API, only parsed FROM the API.
public struct BalanceResponse: Codable {
    public let balance: ZilAmount
    public let nonce: Nonce
}

extension Nonce: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nonce = try container.decode(UInt64.self)
        self.init(nonce)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(nonce)
    }
}
