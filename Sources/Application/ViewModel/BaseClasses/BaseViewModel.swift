// MIT License — Copyright (c) 2018-2026 Open Zesame

import Foundation

class BaseViewModel<NavigationStep, InputFromView, OutputFromViewModel>: AbstractViewModel<
    InputFromView,
    InputFromController,
    OutputFromViewModel
> {
    let navigator: Navigator<NavigationStep>

    init(navigator: Navigator<NavigationStep> = Navigator<NavigationStep>()) {
        self.navigator = navigator
    }
}

extension BaseViewModel: Navigating {}
