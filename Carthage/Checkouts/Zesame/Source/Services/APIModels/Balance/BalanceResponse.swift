//
//  BalanceResponse.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct BalanceResponse: Decodable {
    public let balance: Amount
    public let nonce: Nonce
}

extension Amount: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}


extension Nonce: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nonce = try container.decode(Int.self)
        self.init(nonce)
    }
}
