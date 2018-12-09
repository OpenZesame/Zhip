//
//  AddressValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

struct AddressValidator: InputValidator {
    typealias Input = String
    typealias Output = Address
    typealias Error = Address.Error

    func validate(input: Input) -> InputValidationResult<Output> {
        do {
            return .valid(try Address(hexString: input))
        } catch let addressError as Address.Error {
            return .invalid(.error(message: addressError.errorMessage))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
}

extension Address.Error: InputError {
    var errorMessage: String {
        let Message = L10n.Error.Input.Address.self

        switch self {
        case .containsInvalidCharacters: return Message.containsNonHexadecimal
        case .tooLong: return Message.tooLong(Address.lengthOfValidAddresses)
        case .tooShort: return Message.tooShort(Address.lengthOfValidAddresses)
        }
    }
}
