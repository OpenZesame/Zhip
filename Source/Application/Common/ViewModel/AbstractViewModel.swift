//
//  AbstractViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AbstractViewModel<Step, InputFromView, OutputType>: ViewModelType, Navigatable {
    let bag = DisposeBag()
    let stepper: Stepper<Step>

    init(stepper: Stepper<Step> = Stepper<Step>()) {
        self.stepper = stepper
    }

    struct Input: InputType {
        typealias FromView = InputFromView
        let fromController: ControllerInput
        let fromView: FromView

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    typealias Output = OutputType

    func transform(input: Input) -> Output {
        fatalError("override me")
    }
}
