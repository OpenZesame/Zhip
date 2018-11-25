//
//  AddressValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import Validator

struct AddressValidator: InputValidator, ValidationRulesOwner {

    enum Error {
        case containsNonHexadecimalCharacters
        case addressTooShort
        case addressTooLong
    }

    private let onlyHexChars = ValidationRuleHexadecimalCharacters(error: Error.containsNonHexadecimalCharacters)
    private let lengthMin = ValidationRuleLength(min: Address.lengthOfValidAddresses, error: Error.addressTooShort)
    private let lengthMax = ValidationRuleLength(max: Address.lengthOfValidAddresses, error: Error.addressTooLong)

    var rules: ValidationRuleSet<String> {
        var rules = ValidationRuleSet<String>(rules: [onlyHexChars])
        [lengthMin, lengthMax].forEach { rules.add(rule: $0) }
        return rules
    }
}

extension AddressValidator.Error: InputError {
    var errorMessage: String {
        let Message = L10n.Error.Input.Address.self

        switch self {
        case .containsNonHexadecimalCharacters: return Message.containsNonHexadecimal
        case .addressTooLong: return Message.tooLoong(Address.lengthOfValidAddresses)
        case .addressTooShort: return Message.tooShort(Address.lengthOfValidAddresses)
        }
    }
}
