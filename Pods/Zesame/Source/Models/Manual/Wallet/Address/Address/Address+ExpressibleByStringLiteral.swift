//
//  Address+ExpressibleByStringLiteral.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - ExpressibleByStringLiteral
extension Address: ExpressibleByStringLiteral {}
public extension Address {
    public init(stringLiteral value: String) {
        do {
            try self.init(string: value)
        } catch {
            fatalError("Not a valid address, error: `\(error)`")
        }
    }
}
