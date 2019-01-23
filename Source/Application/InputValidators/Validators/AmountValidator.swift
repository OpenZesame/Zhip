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

struct AmountValidator: InputValidator {

    typealias Error = AmountError<Zil>

    func validate(input zil: String) -> Validation<ZilAmount, Error> {
        do {
            return .valid(try ZilAmount(zil: zil))
        } catch {
            return self.error(Error(error: error)!)
        }
    }
}

private typealias € = L10n.Error.Input.Amount

enum AmountError<ConvertTo: ExpressibleByAmount>: Swift.Error, InputError {
    case tooLarge(max: String, unit: Unit)
    case tooSmall(min: String, unit: Unit)
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

    init<T>(zesameError: Zesame.AmountError<T>) where T: ExpressibleByAmount & Upperbound & Lowerbound {
        switch zesameError {
        case .nonNumericString: self = .nonNumericString
        case .tooLarge(let max):
            let convertedMax = max.asString(in: ConvertTo.unit)
            self = .tooLarge(max: convertedMax, unit: ConvertTo.unit)
        case .tooSmall(let min):
            let convertedMin = min.asString(in: ConvertTo.unit)
            self = .tooSmall(min: convertedMin, unit: ConvertTo.unit)
        }
    }

    init<T>(zesameError: Zesame.AmountError<T>) where T: ExpressibleByAmount & Unbound {
        switch zesameError {
        case .nonNumericString: self = .nonNumericString
        case .tooLarge, .tooSmall: incorrectImplementation("Unbound amounts should not throw `tooLarge` or `tooSmall` errors")
        }
    }

    var errorMessage: String {
        switch self {
        case .tooLarge(let max, let unit): return €.tooLarge("\(max.thousands) \(unit.name)")
        case .tooSmall(let min, let unit): return €.tooSmall("\(min.thousands) \(unit.name)")
        case .nonNumericString: return €.nonNumericString
        }
    }
}
