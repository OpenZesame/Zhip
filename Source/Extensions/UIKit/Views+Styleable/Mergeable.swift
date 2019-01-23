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

public protocol Mergeable {
    func merged(other: Self, mode: MergeMode) -> Self
}

extension Mergeable {
    func merge(yieldingTo other: Self?) -> Self {
        guard let other = other else { return self }
        return merge(yieldingTo: other)
    }

    func merge(yieldingTo other: Self) -> Self {
        return merged(other: other, mode: .yieldToOther)
    }

    func merge(overridingOther other: Self?) -> Self {
        guard let other = other else { return self }
        return merge(overridingOther: other)
    }

    func merge(overridingOther other: Self) -> Self {
        return merged(other: other, mode: .overrideOther)
    }
}

public extension Mergeable {
    func mergeAttribute<T>(other: Self, path attributePath: KeyPath<Self, T?>, mode: MergeMode) -> T? {
        let selfAttribute = self[keyPath: attributePath]
        let otherAttribute = other[keyPath: attributePath]
        switch mode {
        case .overrideOther: return selfAttribute ?? otherAttribute
        case .yieldToOther: return otherAttribute ?? selfAttribute
        }
    }
}

public enum MergeMode {
    case overrideOther
    case yieldToOther
}

extension Optional where Wrapped: Mergeable {
    func merge(overridingOther other: Wrapped) -> Wrapped {
        return merged(other: other, mode: .overrideOther)
    }

    func merge(yieldingTo other: Wrapped) -> Wrapped {
        return merged(other: other, mode: .yieldToOther)
    }

    private func merged(other: Wrapped, mode: MergeMode) -> Wrapped {
        guard let `self` = self else { return other }
        return `self`.merged(other: other, mode: mode)
    }
}
