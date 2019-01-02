//
//  ConfirmWalletRemovalViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum ConfirmWalletRemovalUserAction: String, TrackedUserAction {
    case /*user did*/cancel, confirm
}

// MARK: - ConfirmWalletRemovalViewModel
private typealias € = L10n.Scene.ConfirmWalletRemoval

final class ConfirmWalletRemovalViewModel: BaseViewModel<
    ConfirmWalletRemovalUserAction,
    ConfirmWalletRemovalViewModel.InputFromView,
    ConfirmWalletRemovalViewModel.Output
> {
    private let useCase: WalletUseCase

    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        // MARK: Navigate
        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            input.fromView.confirmTrigger
                .do(onNext: { userDid(.confirm) })
                .drive()
        ]

        // MARK: Return output
        return Output(
            isConfirmButtonEnabled: input.fromView.isWalletBackedUpCheckboxChecked
        )
    }
}

extension ConfirmWalletRemovalViewModel {
    
    struct InputFromView {
        let confirmTrigger: Driver<Void>
        let isWalletBackedUpCheckboxChecked: Driver<Bool>
    }

    struct Output {
        let isConfirmButtonEnabled: Driver<Bool>
    }
}
