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
