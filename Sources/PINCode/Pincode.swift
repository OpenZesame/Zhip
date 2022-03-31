//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation

public struct Pincode: Hashable, Codable, CustomDebugStringConvertible {
    public let digits: [Digit]

    public init(digits: [Digit]) throws {
        if digits.count < Pincode.minLength { throw Error.pincodeTooShort }
        if digits.count > Pincode.maxLength { throw Error.pincodeTooLong }
        self.digits = digits
    }
}

// MARK: - Pincode init
// MARK: -
public extension Pincode {
	init(string: String) throws {
		try self.init(
			digits: string.compactMap { Digit(string: String($0)) }
		)
	}
}

public extension Pincode {
    var debugDescription: String {
        digits.map {
            String(describing: $0)
        }.joined(separator: "")
    }
}

// MARK: Minimum length
public extension Pincode {
    static let minLength: Int = 4
    static let maxLength: Int = 8
}

// MARK: - Error
public extension Pincode {
    enum Error: Swift.Error {
        case pincodeTooLong
        case pincodeTooShort
    }
}


public enum Digit: Int, Codable, Hashable {
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
