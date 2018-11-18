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
        func userIntends(to intention: Step) {
            stepper.step(intention)
        }

        let fromView = input.fromView

        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .restore
        
        let validEncryptionPassphrase: Driver<String?> = Observable.combineLatest(
            fromView.encryptionPassphrase.asObservable(),
            fromView.confirmEncryptionPassphrase.asObservable()
        ) {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $1, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }.asDriverOnErrorReturnEmpty()

        let validPrivateKey: Driver<String?> = fromView.privateKey.map {
            guard
                case let key = $0,
                key.count <= 64
                else { return nil }
            return key
        }
        
        let keyRestorationKeystore: Driver<KeyRestoration?> = Driver.combineLatest(fromView.keystoreText, validEncryptionPassphrase) {
            guard let newEncryptionPassphrase = $1 else { return nil }
            return try? KeyRestoration(keyStoreJSONString: $0, encryptedBy: newEncryptionPassphrase)
        }
        
        let keyRestorationPrivateKey: Driver<KeyRestoration?> = Driver.combineLatest(validPrivateKey, validEncryptionPassphrase) {
            guard let privateKeyHex = $0, let newEncryptionPassphrase = $1 else { return nil }
            return try? KeyRestoration(privateKeyHexString: privateKeyHex, encryptBy: newEncryptionPassphrase)
        }
        
        let keyRestoration = Driver.merge(keyRestorationKeystore, keyRestorationPrivateKey)

        let activityIndicator = ActivityIndicator()

        bag <~ [
            fromView.restoreTrigger
                .withLatestFrom(keyRestoration.filterNil()) { $1 }
                .flatMapLatest { [unowned self] in
                    self.useCase.restoreWallet(from: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userIntends(to: .restoreWallet($0)) })
                .drive()
        ]

        let isRestoreButtonEnabled = Driver.combineLatest(
            keyRestoration.map { $0 != nil },
            validEncryptionPassphrase.map { $0 != nil }
        ) { $0 && $1}

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        return Output(
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            isRestoreButtonEnabled: isRestoreButtonEnabled,
            isRestoreButtonLoading: activityIndicator.asDriver()
        )
    }
}

extension RestoreWalletViewModel {
    
    struct InputFromView {
        let privateKey: Driver<String>
        let keystoreText: Driver<String>
        
        let encryptionPassphrase: Driver<String>
        let confirmEncryptionPassphrase: Driver<String>
        
        let restoreTrigger: Driver<Void>
    }
    
    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let isRestoreButtonEnabled: Driver<Bool>
        let isRestoreButtonLoading: Driver<Bool>
    }
}
