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
import XCTest

extension XCTestCase {

    /// Processes main-runloop events for `seconds` so UIKit presentation and
    /// Combine `.receive(on: RunLoop.main)` work can settle before the test
    /// asserts.
    ///
    /// **Why not `DispatchQueue.main.asyncAfter` + `wait(for:timeout:)`?**
    /// Every coordinator test originally used an expectation fulfilled by an
    /// `asyncAfter(deadline: .now() + seconds)`, then waited with a 1.1s
    /// timeout. On CI (and intermittently locally) modal-presentation and
    /// `openUrl` branches keep the main queue busy longer than that
    /// expectation tolerates — the scheduled fulfill never runs inside the
    /// allotted window and the test fails as a flake. `RunLoop.run(until:)`
    /// just processes events for the requested window and returns, without
    /// any XCTest expectation machinery racing the main queue.
    func drainRunLoop(seconds: TimeInterval = 0.1) {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: seconds))
    }
}
