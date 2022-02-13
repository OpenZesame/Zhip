//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation

public struct Pincode: Equatable, Codable {
    public let digits: [Digit]

    public init(digits: [Digit]) throws {
        if digits.count > Pincode.length { throw Error.pincodeTooLong }
        if digits.count < Pincode.length { throw Error.pincodeTooShort }
        self.digits = digits
    }
}

// MARK: Minimum length
public extension Pincode {
    static let length: Int = 4
}

// MARK: - Error
public extension Pincode {
    enum Error: Swift.Error {
        case pincodeTooLong
        case pincodeTooShort
    }
}


public enum Digit: Int, Codable, Equatable {
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

public extension Digit {
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
    public var description: String {
        return String(describing: rawValue)
    }
}
