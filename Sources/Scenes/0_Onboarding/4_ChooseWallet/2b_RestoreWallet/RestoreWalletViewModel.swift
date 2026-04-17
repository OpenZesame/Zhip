//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Zesame

/// Navigation from RestoreWallet
enum RestoreWalletNavigation {
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

    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let activityIndicator = ActivityIndicator()

        let keyRestoration: AnyPublisher<KeyRestoration?, Never> = input.fromView.selectedSegment.flatMapLatest {
            switch $0 {
            case .keystore: input.fromView.keyRestorationUsingKeystore
            case .privateKey: input.fromView.keyRestorationUsingPrivateKey
            }
        }
        .eraseToAnyPublisher()

        let headerLabel: AnyPublisher<String, Never> = input.fromView.selectedSegment.map {
            switch $0 {
            case .keystore: String(localized: .RestoreWallet.restoreWithKeystore)
            case .privateKey: String(localized: .RestoreWallet.restoreWithPrivateKey)
            }
        }.eraseToAnyPublisher()

        let errorTracker = ErrorTracker()

        [
            input.fromView.restoreTrigger.withLatestFrom(keyRestoration.filterNil()) { $1 }
                .flatMapLatest { [unowned self] in
                    self.useCase.restoreWallet(from: $0)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .replaceErrorWithEmpty()
                }
                .sink { userIntends(to: .restoreWallet($0)) },
        ].forEach { $0.store(in: &cancellables) }

        let keystoreRestorationError: AnyPublisher<AnyValidation, Never> = errorTracker.asInputValidationErrors {
            KeystoreValidator.Error(error: $0)
        }

        return Output(
            headerLabel: headerLabel,
            isRestoreButtonEnabled: keyRestoration.map { $0 != nil }.eraseToAnyPublisher(),
            isRestoring: activityIndicator.asPublisher(),
            keystoreRestorationError: keystoreRestorationError
        )
    }
}

extension RestoreWalletViewModel {
    struct InputFromView {
        enum Segment: Int {
            case privateKey, keystore
        }

        let selectedSegment: AnyPublisher<Segment, Never>
        let keyRestorationUsingPrivateKey: AnyPublisher<KeyRestoration?, Never>
        let keyRestorationUsingKeystore: AnyPublisher<KeyRestoration?, Never>
        let restoreTrigger: AnyPublisher<Void, Never>
    }

    struct Output {
        let headerLabel: AnyPublisher<String, Never>
        let isRestoreButtonEnabled: AnyPublisher<Bool, Never>
        let isRestoring: AnyPublisher<Bool, Never>
        let keystoreRestorationError: AnyPublisher<AnyValidation, Never>
    }
}
