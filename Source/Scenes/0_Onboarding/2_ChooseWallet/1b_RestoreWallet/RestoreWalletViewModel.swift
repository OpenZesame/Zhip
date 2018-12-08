//
//  RestoreWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet

/// Navigation from RestoreWallet
enum RestoreWalletNavigation: TrackedUserAction {
    case restoreWallet(Wallet)
}

// MARK: - RestoreWalletViewModel
final class RestoreWalletViewModel: BaseViewModel<
    RestoreWalletNavigation,
    RestoreWalletViewModel.InputFromView,
    RestoreWalletViewModel.Output
> {
    
    private let useCase: WalletUseCase
    private let restoreUsingPrivateKeyViewModel = RestoreWalletUsingPrivateKeyViewModel()
    private let restoreUsingKeyStoreViewModel = RestoreWalletUsingKeystoreViewModel()
    
    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }
    
    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let activityIndicator = ActivityIndicator()

        bag <~ [
            input.fromView.keyRestoration
                .flatMapLatest { [unowned self] in
                    self.useCase.restoreWallet(from: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userIntends(to: .restoreWallet($0)) })
                .drive()
        ]

        return Output(
            restoreUsingPrivateKeyViewModel: restoreUsingPrivateKeyViewModel,
            restoreUsingKeyStoreViewModel: restoreUsingKeyStoreViewModel,
            isRestoring: activityIndicator.asDriver()
        )
    }
}

extension RestoreWalletViewModel {
    
    struct InputFromView {
        let keyRestoration: Driver<KeyRestoration>
    }
    
    struct Output {
        let restoreUsingPrivateKeyViewModel: RestoreWalletUsingPrivateKeyViewModel
        let restoreUsingKeyStoreViewModel: RestoreWalletUsingKeystoreViewModel
        let isRestoring: Driver<Bool>
    }
}
