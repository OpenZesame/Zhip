//
//  TransactionResponse.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct TransactionResponse: Decodable {
    public let info: String
    public let transactionIdentifier: String

    public enum CodingKeys: String, CodingKey {
        case transactionIdentifier = "TranID"
        case info = "Info"
    }
}
