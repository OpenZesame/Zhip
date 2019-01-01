//
//  ExpressibleByAmount+Compare+AandB.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public func == <A, B>(lhs: A, rhs: B) -> Bool where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return lhs.inQa == rhs.inQa
}

public func <= <A, B>(lhs: A, rhs: B) -> Bool where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return lhs.inQa <= rhs.inQa
}

public func >= <A, B>(lhs: A, rhs: B) -> Bool where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return lhs.inQa >= rhs.inQa
}

public func != <A, B>(lhs: A, rhs: B) -> Bool where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return lhs.inQa != rhs.inQa
}

public func > <A, B>(lhs: A, rhs: B) -> Bool where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return lhs.inQa > rhs.inQa
}

public func < <A, B>(lhs: A, rhs: B) -> Bool where A: ExpressibleByAmount, B: ExpressibleByAmount {
    return lhs.inQa < rhs.inQa
}
