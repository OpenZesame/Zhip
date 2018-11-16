//
//  ChooseWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - ChooseWalletNavigation
enum ChooseWalletNavigation: String, TrackedUserAction {
    case userSelectedCreateNewWallet
    case userSelectedRestoreWallet
}

// MARK: - ChooseWalletViewModel
final class ChooseWalletViewModel: BaseViewModel<
    ChooseWalletNavigation,
    ChooseWalletViewModel.InputFromView,
    ChooseWalletViewModel.Output
> {

    override func transform(input: Input) -> Output {
        let fromView = input.fromView

        bag <~ [
            fromView.createNewTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.userSelectedCreateNewWallet)
            }).drive(),

            fromView.restoreTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.userSelectedRestoreWallet)
            }).drive()
        ]
        return Output()
    }
}

extension ChooseWalletViewModel {

    struct InputFromView {
        let createNewTrigger: Driver<Void>
        let restoreTrigger: Driver<Void>
    }

    struct Output {}
}
