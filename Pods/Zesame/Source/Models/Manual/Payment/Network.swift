// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import EllipticCurveKit

/// seemore: https://apidocs.zilliqa.com/#getnetworkid
public enum Network: UInt32, Decodable {
    case mainnet = 1
    case testnet = 333
}

// MARK: - Decodable
public extension Network {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let chainIdAsString = try container.decode(String.self)
        guard let chainId = UInt32(chainIdAsString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to parse chain id string (`\(chainIdAsString)`) as integer")
        }
        guard let network = Network(rawValue: chainId) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Received new chain id: \(chainId), you need to add this to the enum `Network`")
        }
        self = network
    }
}

public extension Network {
    static var `default`: Network {
        return .mainnet
    }
}

public extension Network {
    var chainId: UInt32 {
        return rawValue
    }
}
