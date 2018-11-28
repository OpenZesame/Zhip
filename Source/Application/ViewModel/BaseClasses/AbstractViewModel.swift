//
//  BaseViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel<NavigationStep, InputFromView, OutputFromViewModel>: AbstractViewModel<
    InputFromView,
    ControllerInput,
    OutputFromViewModel
> {
    let stepper: Stepper<NavigationStep>

    init(stepper: Stepper<Step> = Stepper<Step>()) {
        self.stepper = stepper
    }

    deinit {
        log.verbose("💣 \(type(of: self))")
    }
}

extension BaseViewModel: Navigatable {}

/// Subclasses passing the `Step` type to this class should not declare the `Step` type as a nested type due to a swift compiler bug
/// read more: https://bugs.swift.org/browse/SR-9160
class AbstractViewModel<FromView, FromController, Output> {
    let bag = DisposeBag()

    struct Input: InputType {

        let fromController: FromController
        let fromView: FromView

        init(fromView: FromView, fromController: FromController) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    func transform(input: Input) -> Output { abstract }
}

extension AbstractViewModel: ViewModelType {}
