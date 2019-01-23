//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
