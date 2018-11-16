//
//  Pincode.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

struct Pincode: Equatable, Codable {
    let digits: [Digit]

    init(digits: [Digit]) throws {
        if digits.count > Pincode.length { throw Error.pincodeTooLong }
        if digits.count < Pincode.length { throw Error.pincodeTooShort }
        self.digits = digits
    }
}

// MARK: Minimum length
extension Pincode {
    static let length: Int = 4
}

// MARK: - Error
extension Pincode {
    enum Error: Swift.Error {
        case pincodeTooLong
        case pincodeTooShort
    }
}
