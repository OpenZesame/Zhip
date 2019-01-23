//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Zesame

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet

/// Navigation from RestoreWallet
enum RestoreWalletNavigation: TrackableEvent {
    case restoreWallet(Wallet)

    var eventName: String {
        switch self {
        case .restoreWallet: return "restoreWallet"
        }
    }

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

        let keystoreRestorationError: Driver<AnyValidation> = errorTracker.asInputValidationErrors {
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
        let keystoreRestorationError: Driver<AnyValidation>
    }
}
