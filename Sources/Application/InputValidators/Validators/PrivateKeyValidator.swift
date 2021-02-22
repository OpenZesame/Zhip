// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
