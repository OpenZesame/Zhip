//
//  StatusOfTransactionRequest.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-11.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import JSONRPCKit

// The receipt for a transaction that the network has reached consensus for.
public struct TransactionReceipt {
    public let transactionId: String
    public let totalGasCost: Amount
    public init(id: String, totalGasCost: Amount) {
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
        public let totalGasCost: Amount
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
        self.totalGasCost = try Amount(string: costAsString)
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
