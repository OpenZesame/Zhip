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
