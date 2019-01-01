//
//  UInt256+ExpressibleByStringLiteral.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-06-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

extension String {
    func splittingIntoSubStringsOfLength(_ length: Int) -> [String] {
        guard count % length == 0 else { fatalError("bad length") }
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}

// MARK: - From String
public extension BigUInt {
    public init?(string: String) {
        if string.starts(with: "0x") {
            self.init(String(string.dropFirst(2)), radix: 16)
        } else {
            self.init(string, radix: 10)
        }
    }
}
