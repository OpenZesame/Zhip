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
