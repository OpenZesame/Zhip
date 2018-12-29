//
//  Transaction.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct TransactionIntent: Codable {
    let amount: ZilAmount
    let recipient: Address

    init(amount: ZilAmount, to recipient: Address) {
        self.amount = amount
        self.recipient = recipient
    }
}
