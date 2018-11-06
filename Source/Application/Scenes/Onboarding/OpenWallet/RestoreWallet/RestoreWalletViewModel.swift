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
import SwiftValidator

// MARK: - RestoreWalletNavigation
enum RestoreWalletNavigation: TrackedUserAction {
    case userInitiatedRestorationOfWallet(Wallet)
}

// MARK: - RestoreWalletViewModel
final class RestoreWalletViewModel: AbstractViewModel<
    RestoreWalletNavigation,
    RestoreWalletViewModel.InputFromView,
    RestoreWalletViewModel.Output
> {
    private let useCase: ChooseWalletUseCase
    
    init(useCase: ChooseWalletUseCase) {
        self.useCase = useCase
    }
    
    override func transform(input: Input) -> Output {
        
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
        
        
        let wallet = keyRestoration.filterNil().flatMapLatest {
            self.useCase.restoreWallet(from: $0)
                .asDriverOnErrorReturnEmpty()
        }
        
        bag <~ [
            fromView.restoreTrigger
                .withLatestFrom(wallet).do(onNext: { [unowned stepper] in
                    stepper.step(.userInitiatedRestorationOfWallet($0))
                })
                .drive()
        ]

        let isRestoreButtonEnabled = Driver.combineLatest(
            keyRestoration.map { $0 != nil },
            validEncryptionPassphrase.map { $0 != nil }
        ) { $0 && $1}

        return Output(
            encryptionPassphrasePlaceholder: .just("Encryption passphrase (min \(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)) chars)"),
            isRestoreButtonEnabled: isRestoreButtonEnabled
        )
    }
}

extension RestoreWalletViewModel {
    
    struct InputFromView {
        let validator: Validator
        let privateKey: Driver<String>
        let keystoreText: Driver<String>
        
        let encryptionPassphrase: Driver<String>
        let confirmEncryptionPassphrase: Driver<String>
        
        let restoreTrigger: Driver<Void>
    }
    
    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let isRestoreButtonEnabled: Driver<Bool>
    }
}
