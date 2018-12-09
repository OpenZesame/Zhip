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

    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let activityIndicator = ActivityIndicator()

        let keyRestoration: Driver<KeyRestoration?> = input.fromView.selectedSegment.flatMapLatest {
            switch $0 {
            case .keystore: return input.fromView.keyRestorationUsingKeystore
            case .privateKey: return input.fromView.keyRestorationUsingPrivateKey
            }
        }

        bag <~ [
            input.fromView.restoreTrigger.withLatestFrom(keyRestoration.filterNil()) { $1 }
                .flatMapLatest { [unowned self] in
                    self.useCase.restoreWallet(from: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userIntends(to: .restoreWallet($0)) })
                .drive()
        ]

        return Output(
            isRestoreButtonEnabled: keyRestoration.map { $0 != nil },
            isRestoring: activityIndicator.asDriver()
        )
    }
}

extension RestoreWalletViewModel {
    
    struct InputFromView {
        enum Segment: Int {
            case privateKey, keystore
        }
        let selectedSegment: Driver<Segment>
        let keyRestorationUsingPrivateKey: Driver<KeyRestoration?>
        let keyRestorationUsingKeystore: Driver<KeyRestoration?>
        let restoreTrigger: Driver<Void>
    }
    
    struct Output {
        let isRestoreButtonEnabled: Driver<Bool>
        let isRestoring: Driver<Bool>
    }
}
