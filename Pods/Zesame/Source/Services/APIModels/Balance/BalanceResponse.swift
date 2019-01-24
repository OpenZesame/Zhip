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
