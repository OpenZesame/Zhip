//
//  Qa.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public typealias Qa = UnboundAmount<MeasuredInQa>

public struct MeasuredInQa: UnitSpecifying {
    public static let unit: Unit = .qa
}
