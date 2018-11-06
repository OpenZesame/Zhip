//
//  Transaction.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct Transaction: Codable {
    let amount: Double
    let recipient: Address

    init(amount: Amount, to recipient: Address) {
        self.amount = amount.amount
        self.recipient = recipient
    }
}
