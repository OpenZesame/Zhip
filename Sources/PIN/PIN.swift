//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation

public struct PIN: Hashable, Codable, CustomDebugStringConvertible {
    public let digits: [Digit]

    public init(digits: [Digit]) throws {
        if digits.count < PIN.minLength { throw Error.pincodeTooShort }
        if digits.count > PIN.maxLength { throw Error.pincodeTooLong }
        self.digits = digits
    }
}

// MARK: - PIN init
// MARK: -
public extension PIN {
	init(string: String) throws {
		try self.init(
			digits: string.compactMap { Digit(string: String($0)) }
		)
	}
}

public extension PIN {
    var debugDescription: String {
        digits.map {
            String(describing: $0)
        }.joined(separator: "")
    }
}

// MARK: Minimum length
public extension PIN {
    static let minLength: Int = 4
    static let maxLength: Int = 8
}

// MARK: - Error
public extension PIN {
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
