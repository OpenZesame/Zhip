// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
