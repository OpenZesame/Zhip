//
//  TransactionRequest.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
