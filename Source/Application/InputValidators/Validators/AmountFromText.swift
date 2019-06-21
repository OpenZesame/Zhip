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

enum AmountFromText<Amount: ExpressibleByAmount> {
    case amount(Amount, in: Zesame.Unit)
    case string(String)
}

extension AmountFromText {
    var amount: Amount? {
        guard case let .amount(amount, _) = self else { return nil }
        return amount
    }
    
    var string: String? {
        guard case let .string(text) = self else { return nil }
        return text
    }
}

extension AmountFromText {
    
    // swiftlint:disable:next function_body_length
    init(string amountString: String, unit: Zesame.Unit) throws {
        let correctSeparator = Locale.current.decimalSeparatorForSure
        let wrongSeparator = correctSeparator == "." ? "," : "."
        
        let incorrectDecimalSeparatorRemoved = amountString.replacingOccurrences(of: wrongSeparator, with: correctSeparator)
        do {
            let amount: Amount
            switch unit {
            case .zil:
                amount = try Amount(zil: try Zil(trimming: incorrectDecimalSeparatorRemoved))
            case .li:
                amount = try Amount(li: try Li(trimming: incorrectDecimalSeparatorRemoved))
            case .qa:
                amount = try Amount(qa: try Qa(trimming: incorrectDecimalSeparatorRemoved))
            }
            self = .amount(amount, in: unit)
        } catch {
            if let zilAmountError = error as? Zesame.AmountError<Amount>, zilAmountError == .endsWithDecimalSeparator {
                self = .string(incorrectDecimalSeparatorRemoved)
            } else if let zilError = error as? Zesame.AmountError<Zil>, zilError == .endsWithDecimalSeparator {
                self = .string(incorrectDecimalSeparatorRemoved)
            } else {
                throw error
            }
        }
    }
}
