//
//  WarningERC20ViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WarningERC20ActionListener: AnyObject {
    func understandsERC20Risk()
    func doNotShowERC20WarningAgain()
}

final class WarningERC20ViewModel {

    private let bag = DisposeBag()

    private weak var actionListener: WarningERC20ActionListener?
    private let useCase: OnboardingUseCase

    init(actionListener: WarningERC20ActionListener, useCase: OnboardingUseCase) {
        self.actionListener = actionListener
        self.useCase = useCase
    }

}

extension WarningERC20ViewModel: ViewModelType {
    struct Input: InputType {
        struct FromView {
            let accept: Driver<Void>
            let doNotShowAgain: Driver<Void>
        }
        let fromView: FromView
        let fromController: ControllerInput

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {}

    func transform(input: Input) -> Output {

        let fromView = input.fromView

        bag <~ [
            fromView.accept.do(onNext: {
                self.actionListener?.understandsERC20Risk()
            }).drive(),

            fromView.doNotShowAgain.do(onNext: {
                self.useCase.doNotShowERC20WarningAgain()
                self.actionListener?.doNotShowERC20WarningAgain()
            }).drive()
        ]

        return Output()
    }
}
