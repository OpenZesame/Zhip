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

    /// Drains the main runloop for `seconds` so UIKit presentation and
    /// Combine `.receive(on: DispatchQueue.main)` work can settle before
    /// the test asserts.
    ///
    /// **Why not `XCTestExpectation` + `DispatchQueue.main.asyncAfter`?**
    /// That pattern made the test depend on GCD's timer subsystem firing
    /// the asyncAfter block within the timeout. On CI the timer was
    /// occasionally starved for >10s during the first window-bound test or
    /// during modal presentation, producing flakes like "Asynchronous wait
    /// failed: Exceeded timeout of 10.1 seconds, with unfulfilled
    /// expectations: 'runloop drain'". Pumping the runloop directly removes
    /// the dependency on the GCD timer entirely.
    ///
    /// **Why not bare `RunLoop.run(until:)`?** It returns immediately when
    /// the mode has no input sources, which is sometimes true on the CI
    /// simulator before any UI work has been queued. The repeat-while loop
    /// here re-enters until the real-time deadline elapses, so it works in
    /// both the "lots of sources" and the "no sources yet" cases. While the
    /// runloop is being pumped in `.default` mode, the main-queue dispatch
    /// source fires normally — pending GCD blocks and Combine main-queue
    /// hops still get processed.
    func drainRunLoop(seconds: TimeInterval = 0.1) {
        let endDate = Date(timeIntervalSinceNow: seconds)
        repeat {
            RunLoop.main.run(mode: .default, before: endDate)
        } while Date() < endDate
    }
}
