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

import Zesame

struct AddressValidator: InputValidator {
    typealias Input = String
    typealias Output = Address
//    typealias Error = Address.Error

    func validate(input: Input) -> Validation<Output, Error> {
        do {
            let address = try Address(string: input)
            return .valid(address)
        } catch let addressError as Address.Error {
            let mappedError = Error(fromAddressError: addressError)
            return .invalid(.error(mappedError))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
    
}

extension AddressValidator {
    enum Error: InputError {
        case incorrectLength(expectedLength: Int, butGot: Int)
        case notChecksummed
        case noBech32NorHexstring
    }
}

extension AddressValidator.Error {
    init(fromAddressError: Zesame.Address.Error) {
        switch fromAddressError {
        case .incorrectLength(let expected, _, let butGot): self = .incorrectLength(expectedLength: expected, butGot: butGot)
        case .notChecksummed: self = .notChecksummed
        case .bech32DataEmpty, .notHexadecimal: self = .noBech32NorHexstring
        case .invalidBech32Address(let bechError):
            switch bechError {
            case .checksumMismatch: self = .notChecksummed
            default: self = .noBech32NorHexstring
            }
        }
    }

    var errorMessage: String {
        let Message = L10n.Error.Input.Address.self

        switch self {
        case .noBech32NorHexstring: return Message.invalid
        case .incorrectLength(let expected, let incorrect):
            if incorrect > expected {
                return Message.tooLong(expected)
            } else {
                return Message.tooShort(expected)
            }
        case .notChecksummed: return Message.addressNotChecksummed
        }
    }
}
