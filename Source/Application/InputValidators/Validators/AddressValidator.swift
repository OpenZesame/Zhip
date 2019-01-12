//
//  AddressValidator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
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

extension Address {
    static var lengthOfValidAddresses: Int {
        return AddressNotNecessarilyChecksummed.lengthOfValidAddresses
    }
}
