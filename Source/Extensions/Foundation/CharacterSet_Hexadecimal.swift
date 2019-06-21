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

extension CharacterSet {
    static var hexadecimalDigitsIncluding0x: CharacterSet {
        let afToAF = CharacterSet(charactersIn: "abcdefABCDEF")
        return CharacterSet.decimalDigits
            .union(afToAF)
            .union(CharacterSet(charactersIn: "0x"))
    }
    
    static var bech32IncludingPrefix: CharacterSet {
        
        let lowercase = Zesame.Bech32.alphabetString.lowercased()
        let uppercase = Zesame.Bech32.alphabetString.uppercased()
        
        return CharacterSet(charactersIn: lowercase)
            .union(CharacterSet(charactersIn: uppercase))
            .union(CharacterSet(charactersIn: network.bech32Prefix))
    }
    
    static var bech32OrHexIncludingPrefix: CharacterSet {
        return CharacterSet.bech32IncludingPrefix.union(hexadecimalDigitsIncluding0x)
    }
    
    static var decimalWithSeparator: CharacterSet {
        return CharacterSet.decimalDigits
            .union(CharacterSet(charactersIn: Locale.current.decimalSeparatorForSure))
            .union(CharacterSet(charactersIn: "."))
            .union(CharacterSet(charactersIn: ","))
    }
}
