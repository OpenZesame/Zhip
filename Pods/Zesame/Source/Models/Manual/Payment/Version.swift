//
//  Version.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public struct Version {
    public let value: UInt32

    public init(value: UInt32) {
        self.value = value
    }

    public init(network: Network = .default, transactionVersion: UInt32 = 1) {
        self.init(value: network.chainId << 16 + transactionVersion)
    }
}

extension Version: Equatable {}
extension Version: ExpressibleByIntegerLiteral {}
public extension Version {
    public init(integerLiteral value: UInt32) {
        self.init(value: value)
    }
}

public extension Version {
    static var `default`: Version {
        return Version()
    }
}


// MARK: - Encodable
extension Version: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - Decodable
extension Version: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let version = try container.decode(UInt32.self)
        self.init(value: version)
    }
}
