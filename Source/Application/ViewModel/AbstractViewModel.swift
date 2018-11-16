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

class BaseViewModel<Step, InputFromView, OutputType>: AbstractViewModel<InputFromView, ControllerInput, OutputType>, Navigatable {
    let stepper: Stepper<Step>

    init(stepper: Stepper<Step> = Stepper<Step>()) {
        self.stepper = stepper
    }
}

/// Subclasses passing the `Step` type to this class should not declare the `Step` type as a nested type due to a swift compiler bug
/// read more: https://bugs.swift.org/browse/SR-9160
class AbstractViewModel<InputFromView, InputFromController, OutputType>: ViewModelType {
    let bag = DisposeBag()

    struct Input: InputType {
        typealias FromView = InputFromView
        typealias FromController = InputFromController

        let fromController: FromController
        let fromView: FromView

        init(fromView: FromView, fromController: FromController) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    typealias Output = OutputType

    func transform(input: Input) -> Output { abstract }
}
