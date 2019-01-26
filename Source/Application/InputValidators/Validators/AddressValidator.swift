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
    typealias Error = Address.Error

    func validate(input: Input) -> Validation<Output, Error> {
        do {
            let address = try Address(string: input)
            if address.isChecksummed {
                return .valid(address)
            } else {
                return .valid(address, remark: Error.notChecksummed)
            }
        } catch let addressError as Address.Error {
            return .invalid(.error(addressError))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
}

extension Address.Error: InputError {
    public var errorMessage: String {
        let Message = L10n.Error.Input.Address.self

        switch self {
        case .notHexadecimal: return Message.containsNonHexadecimal
        case .tooLong: return Message.tooLong(Address.lengthOfValidAddresses)
        case .tooShort: return Message.tooShort(Address.lengthOfValidAddresses)
        case .notChecksummed: return Message.addressNotChecksummed
        }
    }
}
