//
//  ExpressibleByAmount+Arithemtic.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public func + <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return try! A(qa: lhs.inQa + rhs.inQa)
}

public func - <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return try! A(qa: lhs.inQa - rhs.inQa)
}
