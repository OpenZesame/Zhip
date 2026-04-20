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

/// A ViewModel's combined input contract.
///
/// Every `ViewModelType` takes one `Input`. The `Input` is split into two channels:
/// `fromView` carries user-intent events (taps, text, toggles), and `fromController`
/// carries lifecycle events and write-back subjects (title, toasts, bar-button
/// updates). `AbstractViewModel.Input` provides the conforming implementation.
protocol InputType {

    /// The view-driven publishers — taps, text, toggle state, etc.
    associatedtype FromView

    /// The controller-driven publishers — `viewDidLoad`, navigation-bar taps, plus
    /// the write-back subjects the ViewModel uses to push title / toast updates.
    associatedtype FromController

    /// The view channel.
    var fromView: FromView { get }

    /// The controller channel.
    var fromController: FromController { get }

    /// Designated initializer. `SceneController` constructs this struct on the
    /// ViewModel's behalf by combining the `View.inputFromView` property with the
    /// lifecycle-derived `InputFromController` it builds itself.
    init(fromView: FromView, fromController: FromController)
}
