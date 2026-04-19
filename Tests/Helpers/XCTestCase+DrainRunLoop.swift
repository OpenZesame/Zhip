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

    /// Drains the main queue for approximately `seconds` so UIKit
    /// presentation and Combine `.receive(on: RunLoop.main)` work can settle
    /// before the test asserts.
    ///
    /// Uses `XCTestExpectation` + `DispatchQueue.main.asyncAfter` rather than
    /// `RunLoop.current.run(until:)` because the latter returns immediately
    /// when there are no input sources on `RunLoop.main` — which is often the
    /// case on the CI simulator before any UI work has actually been queued.
    /// The expectation path forces XCTest to spin the main runloop in its
    /// standard wait mode, which reliably dispatches GCD main-queue blocks
    /// and Combine scheduler work. Timeout headroom is deliberately generous
    /// (10s) so CI's slower main queue never races the fulfill.
    func drainRunLoop(seconds: TimeInterval = 0.1) {
        let drainExpectation = expectation(description: "runloop drain")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            drainExpectation.fulfill()
        }
        wait(for: [drainExpectation], timeout: seconds + 10)
    }
}
