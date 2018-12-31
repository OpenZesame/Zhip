//
//  ExpressibleByAmount+Codable.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-12-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - Encodable
public extension ExpressibleByAmount {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Int(magnitude))
    }
}

// MARK: - Decodable
public extension ExpressibleByAmount {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let qaString = try container.decode(String.self)
        try self.init(qa: qaString)
    }
}
