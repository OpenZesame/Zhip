//
//  TransactionRequest.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import JSONRPCKit

public typealias TransactionIdentifier = String

public struct TransactionRequest: JSONRPCKit.Request {
    public typealias Response = TransactionIdentifier

    public let transaction: Transaction
    public init(transaction: Transaction) {
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
