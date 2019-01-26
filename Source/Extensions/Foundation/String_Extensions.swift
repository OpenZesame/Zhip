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

import UIKit

extension String {

    enum CharacterInsertionPlace {
        case end
    }

    func inserting(string: String, every interval: Int) -> String {
        return String.inserting(string: string, every: interval, in: self)
    }

    static func inserting(
        string character: String,
        every interval: Int,
        in string: String,
        at insertionPlace: CharacterInsertionPlace = .end
    ) -> String {
        guard string.count > interval else { return string }
        var string = string
        var new = ""

        switch insertionPlace {
        case .end:
            while let piece = string.droppingLast(interval) {
                let toAdd: String = string.isEmpty ? "" : character
                new = "\(toAdd)\(piece)\(new)"
            }
            if !string.isEmpty {
                new = "\(string)\(new)"
            }
        }

        return new
    }

    mutating func droppingLast(_ k: Int) -> String? {
        guard k <= count else { return nil }
        let string = String(suffix(k))
        removeLast(k)
        return string
    }

    func sizeUsingFont(_ font: UIFont) -> CGSize {
        return self.size(withAttributes: [.font: font])
    }

    func widthUsingFont(_ font: UIFont) -> CGFloat {
        return sizeUsingFont(font).width
    }
}
