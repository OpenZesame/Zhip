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

func findNestedEnumOfType<Nested>(_ wantedType: Nested.Type, in parent: Any, recursiveTriesLeft: Int) -> Nested? {
    guard recursiveTriesLeft >= 0 else { return nil }

    guard
        case let mirror = Mirror(reflecting: parent),
        let displayStyle = mirror.displayStyle,
        displayStyle == .enum,
        let child = mirror.children.first
        else { return nil }

    guard let needle = child.value as? Nested
        else { return findNestedEnumOfType(wantedType, in: parent, recursiveTriesLeft: recursiveTriesLeft - 1) }

    return needle
}
