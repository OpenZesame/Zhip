//
//  ChooseWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - ChooseWalletUserAction
enum ChooseWalletUserAction: String, TrackedUserAction {
    case createNewWallet
    case restoreWallet
}

// MARK: - ChooseWalletViewModel
final class ChooseWalletViewModel: BaseViewModel<
    ChooseWalletUserAction,
    ChooseWalletViewModel.InputFromView,
    ChooseWalletViewModel.Output
> {

    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        bag <~ [
            input.fromView.createNewWalletTrigger
                .do(onNext: { userIntends(to: .createNewWallet) })
                .drive(),

            input.fromView.restoreWalletTrigger
                .do(onNext: { userIntends(to: .restoreWallet) })
                .drive()
        ]
        return Output()
    }
}

extension ChooseWalletViewModel {

    struct InputFromView {
        let createNewWalletTrigger: Driver<Void>
        let restoreWalletTrigger: Driver<Void>
    }

    struct Output {}
}
