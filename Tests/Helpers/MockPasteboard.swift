//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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
@testable import Zhip

/// In-test `Pasteboard` that NEVER mutates the real `UIPasteboard.general`.
/// Records each `copy(...)` invocation so tests can assert on intent without
/// leaking clipboard data across test runs or onto the host device.
final class MockPasteboard: Pasteboard {

    /// The most recent string passed to `copy(_:)`, or `nil` if no copy has
    /// occurred since this mock was created or reset.
    private(set) var copiedString: String?

    /// Every string passed to `copy(_:)`, in call order.
    private(set) var copyInvocations: [String] = []

    init() {}

    func copy(_ string: String) {
        copiedString = string
        copyInvocations.append(string)
    }
}
