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

import Foundation

extension Bundle {
    enum Key: String {
        case shortVersionString
        case version
        case name

        var key: String {
            return "CFBundle\(rawValue.capitalizingFirstLetter())"
        }
    }

    var version: String? {
        return valueBy(key: .shortVersionString)
    }

    var build: String? {
        return valueBy(key: .version)
    }

    var name: String? {
        return valueBy(key: .name)
    }

    func valueBy(key: Key) -> String? {
        let stringKey = key.key
        return value(of: stringKey)
    }

    func value(of key: String) -> String? {
        guard
            let info = infoDictionary,
            let value = info[key] as? String
            else { return nil }
        return value
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
