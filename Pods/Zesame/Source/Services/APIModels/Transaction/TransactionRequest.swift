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

public struct TransactionRequest: JSONRPCKit.Request {
    public typealias Response = TransactionResponse

    public let transaction: SignedTransaction
    public init(transaction: SignedTransaction) {
        self.transaction = transaction
    }
}

public extension TransactionRequest {
    var method: String {
        return "CreateTransaction"
    }

    var parameters: Encodable? {
        return [transaction]
    }
}
