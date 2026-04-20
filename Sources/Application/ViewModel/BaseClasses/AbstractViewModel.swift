// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

/// Abstract base class providing the boilerplate every concrete ViewModel needs:
/// a `cancellables` bag, a typed `Input` struct, and a `transform(input:)` entry
/// point that subclasses override with real logic.
///
/// Subclasses should inherit from `BaseViewModel` (which wraps this class with a
/// `Navigator`), not directly from `AbstractViewModel`.
class AbstractViewModel<FromView, FromController, OutputFromViewModel>: ViewModelType {

    /// Bag of Combine subscriptions owned by this ViewModel. `transform` implementations
    /// call `.store(in: &cancellables)` on every subscription they create so the
    /// subscriptions outlive the `transform` call and are deinitialized with the
    /// ViewModel.
    var cancellables = Set<AnyCancellable>()

    /// The concrete `InputType` Swift synthesizes for each `AbstractViewModel` subclass.
    struct Input: InputType {

        /// Controller-lifecycle + write-back subjects channel.
        let fromController: FromController

        /// User-driven publishers channel (taps, text, toggles).
        let fromView: FromView

        /// Designated initializer. `SceneController` calls this to stitch together
        /// the two input channels before handing the struct to `transform`.
        init(fromView: FromView, fromController: FromController) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    /// Runs the ViewModel's business logic — must be overridden by subclasses. The
    /// default implementation traps via the `abstract` helper to surface missing
    /// overrides at runtime.
    func transform(input _: Input) -> OutputFromViewModel {
        abstract
    }
}
