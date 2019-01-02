//
//  CharacterSet_Hexadecimal.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension CharacterSet {
    static var hexadecimalDigits: CharacterSet {
        let afToAF = CharacterSet(charactersIn: "abcdefABCDEF")
        return CharacterSet.decimalDigits.union(afToAF)
    }
}
