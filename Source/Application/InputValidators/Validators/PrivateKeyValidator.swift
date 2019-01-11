//
//  PrivateKeyValidator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct PrivateKeyValidator: InputValidator {
    static let expectedLengthOfPrivateKey = 64
    typealias Input = String
    typealias Output = PrivateKey

    enum Error: InputError {
        case tooShort(lengthKeySubmitted: Int)
        case tooLong(lengthKeySubmitted: Int)
        case badPrivateKey
    }

    func validate(input: Input) -> Validation<Output, Error> {
        func validate(privateKeyHex: String) throws -> PrivateKey {
            let lengthKeySubmitted = privateKeyHex.count
            if lengthKeySubmitted < PrivateKeyValidator.expectedLengthOfPrivateKey {
                throw Error.tooShort(lengthKeySubmitted: lengthKeySubmitted)
            }

            if lengthKeySubmitted > PrivateKeyValidator.expectedLengthOfPrivateKey {
                throw Error.tooLong(lengthKeySubmitted: lengthKeySubmitted)
            }

            guard let privateKey = PrivateKey(hex: privateKeyHex) else {
                throw Error.badPrivateKey
            }

            return privateKey
        }

        do {
            return .valid(try validate(privateKeyHex: input))
        } catch let privateError as Error {
            return .invalid(.error(privateError))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
}

extension PrivateKeyValidator.Error {
    var errorMessage: String {
        let Message = L10n.Error.Input.PrivateKey.self
        let expectedLength = PrivateKeyValidator.expectedLengthOfPrivateKey

        switch self {
        case .tooShort(let lengthKeySubmitted): return Message.tooShort(expectedLength, expectedLength - lengthKeySubmitted)
        case .tooLong(let lengthKeySubmitted): return Message.tooLong(expectedLength, lengthKeySubmitted - expectedLength)
        case .badPrivateKey: return Message.badKey
        }
    }
}
