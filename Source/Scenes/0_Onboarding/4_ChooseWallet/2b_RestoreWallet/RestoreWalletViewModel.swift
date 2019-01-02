//
//  RestoreWalletViewModel.swift
//  Zhip
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

        let headerLabel: Driver<String> = input.fromView.selectedSegment.map {
            switch $0 {
            case .keystore: return €.Label.Header.keystore
            case .privateKey: return €.Label.Header.privateKey
            }
        }

        let errorTracker = ErrorTracker()

        bag <~ [
            input.fromView.restoreTrigger.withLatestFrom(keyRestoration.filterNil()) { $1 }
                .flatMapLatest { [unowned self] in
                    self.useCase.restoreWallet(from: $0)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userIntends(to: .restoreWallet($0)) })
                .drive()
        ]

        let keystoreRestorationError: Driver<Validation> = errorTracker.asInputValidationErrors {
            KeystoreValidator.Error(error: $0)
        }

        return Output(
            headerLabel: headerLabel,
            isRestoreButtonEnabled: keyRestoration.map { $0 != nil },
            isRestoring: activityIndicator.asDriver(),
            keystoreRestorationError: keystoreRestorationError
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
        let headerLabel: Driver<String>
        let isRestoreButtonEnabled: Driver<Bool>
        let isRestoring: Driver<Bool>
        let keystoreRestorationError: Driver<Validation>
    }
}
