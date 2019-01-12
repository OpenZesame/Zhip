//
//  AddressChecksummed+Codable.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension AddressChecksummed: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(asString)
    }
}

extension AddressChecksummed: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        try self.init(string: hexString)
    }
}
