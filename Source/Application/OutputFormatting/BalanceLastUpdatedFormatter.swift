//
//  BalanceLastUpdatedFormatter.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

import DateToolsSwift

struct BalanceLastUpdatedFormatter {

    func string(from date: Date?) -> String {
        let Formatter = L10n.Formatter.self
        guard let updatedAt = date else {
            return  Formatter.balanceFirstFetch
        }
        return Formatter.balanceWasUpdatedAt(updatedAt.timeAgoSinceNow.lowercased())
    }
    
}
