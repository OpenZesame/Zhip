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

// MARK: - WarningERC20Navigation
enum WarningERC20Navigation: String, TrackedUserAction {
    case userSelectedRisksAreUnderstood
    case userSelectedRisksAreUnderstoodDoNotShowAgain
}

// MARK: - WarningERC20ViewModel
final class WarningERC20ViewModel: AbstractViewModel<
    WarningERC20Navigation,
    WarningERC20ViewModel.InputFromView,
    WarningERC20ViewModel.Output
> {
    override func transform(input: Input) -> Output {
        bag <~ [
            input.fromView.accept.do(onNext: { [unowned stepper] in
                stepper.step(.userSelectedRisksAreUnderstood)
            }).drive(),
            
            input.fromView.doNotShowAgain.do(onNext: { [unowned stepper] in
                stepper.step(.userSelectedRisksAreUnderstoodDoNotShowAgain)
            }).drive()
        ]
        return Output()
    }
}

extension WarningERC20ViewModel {
    struct InputFromView {
        let accept: Driver<Void>
        let doNotShowAgain: Driver<Void>
    }

    struct Output {}
}
