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
import RxSwift
import RxCocoa

/// Subclasses passing the `Step` type to this class should not declare the `Step` type as a nested type due to a swift compiler bug
/// read more: https://bugs.swift.org/browse/SR-9160
class BaseViewModel<NavigationStep, InputFromView, OutputFromViewModel>: AbstractViewModel<
    InputFromView,
    InputFromController,
    OutputFromViewModel
> {
    let navigator: Navigator<NavigationStep>

    init(navigator: Navigator<NavigationStep> = Navigator<NavigationStep>()) {
        self.navigator = navigator
    }

    func track(event: TrackableEvent) {
        navigator.track(event: event, context: self)
    }
}

extension BaseViewModel: Navigating {}
