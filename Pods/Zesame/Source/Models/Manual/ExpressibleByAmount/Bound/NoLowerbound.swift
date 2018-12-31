//
//  NoLowerbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol NoLowerbound {
    static func - (lhs: Self, rhs: Self) -> Self
}
