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
import JSONRPCKit

// The receipt for a transaction that the network has reached consensus for.
public struct TransactionReceipt {
    public let transactionId: String
    public let totalGasCost: ZilAmount
    public init(id: String, totalGasCost: ZilAmount) {
        self.transactionId = id
        self.totalGasCost = totalGasCost
    }
}

public extension TransactionReceipt {
    init?(for id: String, pollResponse: StatusOfTransactionResponse) {
        guard pollResponse.receipt.isSent else { return nil }
        self.init(id: id, totalGasCost: pollResponse.receipt.totalGasCost)
    }
}

public struct StatusOfTransactionResponse: Decodable {
    public struct Receipt {
        public let totalGasCost: ZilAmount
        public let isSent: Bool
    }

    public let receipt: Receipt
}

extension StatusOfTransactionResponse.Receipt: Decodable {}
public extension StatusOfTransactionResponse.Receipt {

    enum CodingKeys: String, CodingKey {
        case totalGasCost = "cumulative_gas"
        case isSent = "success"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let costAsString = try container.decode(String.self, forKey: .totalGasCost)
        self.totalGasCost = try ZilAmount(zil: costAsString)
        self.isSent = try container.decode(Bool.self, forKey: .isSent)
    }
}

public struct StatusOfTransactionRequest: JSONRPCKit.Request {
    public typealias Response = StatusOfTransactionResponse

    public let transactionId: String
    public init(transactionId: String) {
        self.transactionId = transactionId
    }
}

public extension StatusOfTransactionRequest {
    var method: String {
        return "GetTransaction"
    }

    var parameters: Encodable? {
        return [transactionId]
    }
}
