//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

public struct Version {
    public let value: UInt32

    public init(value: UInt32) {
        self.value = value
    }

    public init(network: Network, transactionVersion: UInt32 = 1) {
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
