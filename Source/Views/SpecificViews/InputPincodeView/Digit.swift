//
//  Digit.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum Digit: Int, Codable, Equatable {
    case zero   = 0
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
}

extension Digit {
    init?(string: String) {
        guard
            let int = Int(string),
            int <= 9,
            int >= 0
            else {
                return nil
        }
        self.init(rawValue: int)
    }
}

extension Digit: CustomStringConvertible {
    var description: String {
        return String(describing: rawValue)
    }
}
