//
//  Transaction.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Transaction {
    let version: Version
    let payment: Payment
    let data: String
    let code: String

    init(payment: Payment, version: Version = .default, data: String = "", code: String = "") {
        self.version = version
        self.payment = payment
        self.data = data
        self.code = code
    }
}
