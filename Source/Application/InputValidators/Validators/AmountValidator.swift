//
//  AmountValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

struct AmountValidator: InputValidator {

    typealias Error = AmountError<Zil>

    func validate(input zil: String) -> InputValidationResult<ZilAmount, Error> {
        do {
            return .valid(try ZilAmount(zil: zil))
        } catch {
            return self.error(Error(error: error)!)
        }
    }
}

private typealias € = L10n.Error.Input.Amount

enum AmountError<ConvertTo: ExpressibleByAmount>: Swift.Error, InputError {
    case tooLarge(max: ConvertTo)
    case tooSmall(min: ConvertTo)
    case nonNumericString

    init?(error: Swift.Error) {
        if let zilError = error as? Zesame.AmountError<Zil> {
            self.init(zesameError: zilError)
        } else if let liError = error as? Zesame.AmountError<Li> {
            self.init(zesameError: liError)
        } else if let qaError = error as? Zesame.AmountError<Qa> {
            self.init(zesameError: qaError)
        } else if let gasPriceError = error as? Zesame.AmountError<GasPrice> {
           self.init(zesameError: gasPriceError)
        } else if let zilAmountError = error as? Zesame.AmountError<ZilAmount> {
            self.init(zesameError: zilAmountError)
        } else {
            return nil
        }
    }

    init<T>(zesameError: Zesame.AmountError<T>) where T: ExpressibleByAmount {
        switch zesameError {
        case .nonNumericString: self = .nonNumericString
        case .tooLarge(let max):
            self = .tooLarge(max: max.as(ConvertTo.self))
        case .tooSmall(let min):
            self = .tooSmall(min: min.as(ConvertTo.self))
        }
    }

    var errorMessage: String {

        switch self {
        case .tooLarge(let max): return €.tooLarge("\(max.formatted(unit: ConvertTo.unit)) \(ConvertTo.unit.name)")
        case .tooSmall(let min): return €.tooSmall("\(min.formatted(unit: ConvertTo.unit)) \(ConvertTo.unit.name)")
        case .nonNumericString: return €.nonNumericString
        }
    }
}
