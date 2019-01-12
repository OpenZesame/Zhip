//
//  HexString+HexStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

extension HexString: HexStringConvertible {}

public extension HexString {
    var hexString: HexString { return self }
}
