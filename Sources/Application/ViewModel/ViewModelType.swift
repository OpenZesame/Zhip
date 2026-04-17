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

/// The central contract every ViewModel conforms to.
///
/// A ViewModel is a pure `Input → Output` transformation: it never holds mutable UI
/// state beyond its `cancellables`, and produces all of its outputs as Combine
/// publishers. `SceneController<View>` wires the `Input` together from view events
/// and lifecycle events, invokes `transform`, and hands the `OutputVM` back to the
/// view via `populate(with:)`.
protocol ViewModelType {

    /// The combined user-action + controller-lifecycle input the ViewModel consumes.
    associatedtype Input: InputType

    /// The bag of publishers the View binds to UI controls.
    associatedtype OutputVM

    /// Runs the ViewModel's business logic.
    ///
    /// Called exactly once per instance, typically by `SceneController`. Implementations
    /// wire `input.fromView` publishers into business logic, subscribe to side-effects
    /// with `.store(in: &cancellables)`, and return an `OutputVM` full of publishers
    /// the View will bind to UI controls.
    func transform(input: Input) -> OutputVM
}
