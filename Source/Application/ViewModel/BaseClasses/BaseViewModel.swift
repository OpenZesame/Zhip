//
//  BaseViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
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

    deinit {
        log.verbose("💣 \(type(of: self))")
    }
}

extension BaseViewModel: Navigating {}
