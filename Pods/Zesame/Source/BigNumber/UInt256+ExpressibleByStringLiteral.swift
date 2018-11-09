//
//  UInt256+ExpressibleByStringLiteral.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-06-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

extension String {
        func splittingIntoSubStringsOfLength(_ length: Int) -> [String] {
            guard count % length == 0 else { fatalError("bad length") }
            var startIndex = self.startIndex
            var results = [Substring]()

            while startIndex < self.endIndex {
                let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
                results.append(self[startIndex..<endIndex])
                startIndex = endIndex
            }

            return results.map { String($0) }
        }
}

// MARK: - From String
public extension BigUInt {

//    //MARK: String Conversion
//
//    /// Calculates the number of numerals in a given radix that fit inside a single `Word`.
//    ///
//    /// - Returns: (chars, power) where `chars` is highest that satisfy `radix^chars <= 2^Word.bitWidth`. `power` is zero
//    ///   if radix is a power of two; otherwise `power == radix^chars`.
//    fileprivate static func charsPerWord(forRadix radix: Int) -> (chars: Int, power: Word) {
//        var power: Word = 1
//        var overflow = false
//        var count = 0
//        while !overflow {
//            let (p, o) = power.multipliedReportingOverflow(by: Word(radix))
//            overflow = o
//            if !o || p == 0 {
//                count += 1
//                power = p
//            }
//        }
//        return (count, power)
//    }

    public init?(string: String) {
        if string.starts(with: "0x") {
            self.init(String(string.dropFirst(2)), radix: 16)
        } else {
            self.init(string, radix: 10)
        }
    }

//    public init?(string: String, radix: Int) {
//        guard radix == 16 else { fatalError("no base other than 16 is supported") }
//        let (charsPerWord, _) = UInt256.charsPerWord(forRadix: radix)
//        guard string.count % charsPerWord == 0 else { fatalError("bad length") }
//        let substringLength = string.count / charsPerWord
//        let substrings = string.splittingIntoSubStringsOfLength(substringLength)
//        let array: [UInt64] = substrings.compactMap { UInt64($0, radix: radix) }
//        guard array.count == substrings.count else { fatalError("wrong length") }
//        self.init(withUInt64Array: array)
//    }

//    /// Initialize a big integer from an ASCII representation in a given radix. Numerals above `9` are represented by
//    /// letters from the English alphabet.
//    ///
//    /// - Requires: `radix > 1 && radix < 36`
//    /// - Parameter `text`: A string consisting of characters corresponding to numerals in the given radix. (0-9, a-z, A-Z)
//    /// - Parameter `radix`: The base of the number system to use, or 10 if unspecified.
//    /// - Returns: The integer represented by `text`, or nil if `text` contains a character that does not represent a numeral in `radix`.
//    public init?(_ text: String, radix: Int = 10) {
//        // FIXME Remove this member when SE-0183 is done
//        self.init(Substring(text), radix: radix)
//    }
//
//    public init?(_ text: Substring, radix: Int = 10) {
//        precondition(radix > 1)
//        let (charsPerWord, power) = UInt256.charsPerWord(forRadix: radix)
//
//        var words: [Word] = []
//        var end = text.endIndex
//        var start = end
//        var count = 0
//        while start != text.startIndex {
//            start = text.index(before: start)
//            count += 1
//            if count == charsPerWord {
//                // FIXME Remove String conversion when SE-0183 is done
//                guard let d = Word(String(text[start ..< end]), radix: radix) else { return nil }
//                let dDescribed = String(describing: d)
//                print("d: `\(dDescribed)`")
//                words.append(d)
//                end = start
//                count = 0
//            }
//        }
//        if start != end {
//            // FIXME Remove String conversion when SE-0183 is done
//            guard let d = Word(String(text[start ..< end]), radix: radix) else { return nil }
//            let dDescribed = String(describing: d)
//            print("d: `\(dDescribed)`")
//            words.append(d)
//        }
//
//        if power == 0 {
//            self.init(withUInt64Array: words)
//        }
//        else {
////            self.init()
//            let wordsMultlipliedByPower = Array(words.reversed()).map { $0 * power }
//            self.init(withUInt64Array: wordsMultlipliedByPower)
////            for d in words.reversed() {
////                self.multiply(byWord: power)
////                self.addWord(d)
////            }
//        }
//    }
}

// MARK: - ExpressibleByStringLiteral
//extension UInt256: ExpressibleByStringLiteral {}
//public extension UInt256 {
//    init(stringLiteral value: String) {
//        guard let fromString = UInt256(string: value) else { fatalError("String not convertible to UInt256") }
//        self = fromString
//    }
//}
