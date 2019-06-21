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

extension String {
    
    func countDecimalPlaces() -> Int {
        
        let decimalSeparator = Locale.current.decimalSeparatorForSure
        
        guard containsDecimalSeparator() else { return 0 }
        
        let components = replacingIncorrectDecimalSeparatorIfNeeded().components(separatedBy: decimalSeparator)
        
        if components.count < 2 { // strange case, should have been covered by `guard containsDecimalSeparator`
            return 0 // integer => 0 decimal places
        } else if components.count > 2 { // contains double separator, not a valid number at all
            fatalError("invalid string")
        } else {
            assert(components.count == 2)
            let decimalStringPart = components.last!
            return decimalStringPart.components(separatedBy: "0").count
        }
    }
    
    func doesNotContainMoreThanOneDecimalSeparator() -> Bool {
        let decimalSeparator = Locale.current.decimalSeparatorForSure
        
        guard replacingIncorrectDecimalSeparatorIfNeeded().components(separatedBy: decimalSeparator).count < 3 else {
            return false
        }
        return true
    }
    
    func replacingIncorrectDecimalSeparatorIfNeeded() -> String {
        
        let decimalSeparator = Locale.current.decimalSeparatorForSure
        
        return self
            .replacingOccurrences(of: ".", with: decimalSeparator)
            .replacingOccurrences(of: ",", with: decimalSeparator)
    }
}

func asStringUsingLocalizedDecimalSeparator(nsDecimalNumber: NSDecimalNumber, maxFractionDigits: Int, minFractionDigits: Int? = nil) -> String? {
    let formatter = NumberFormatter()
    formatter.decimalSeparator = Locale.current.decimalSeparatorForSure
    formatter.maximumFractionDigits = maxFractionDigits
    formatter.minimumIntegerDigits = 1
    if let minFractionDigits = minFractionDigits {
        formatter.minimumFractionDigits = minFractionDigits
    }
    let formattedString = formatter.string(from: nsDecimalNumber)
    return formattedString
}


private extension String {
    
    func containsDecimalSeparator() -> Bool {
        return contains(Locale.current.decimalSeparatorForSure)
    }
}
