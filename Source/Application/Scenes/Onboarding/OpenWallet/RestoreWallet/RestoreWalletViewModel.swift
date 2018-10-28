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

final class RestoreWalletViewModel: AbstractViewModel<
    RestoreWalletViewModel.Step,
    RestoreWalletViewModel.InputFromView,
    RestoreWalletViewModel.Output
> {
    enum Step {
        case didRestore(wallet: Wallet)
    }
    
    private let useCase: ChooseWalletUseCase
    
    init(useCase: ChooseWalletUseCase) {
        self.useCase = useCase
    }
    
    override func transform(input: Input) -> Output {
        
        let fromView = input.fromView
        
        let validEncryptionPassphrase: Driver<String?> = Driver.combineLatest(fromView.encryptionPassphrase, fromView.confirmEncryptionPassphrase) {
            guard
                $0 == $1,
                case let newPassphrase = $0,
                newPassphrase.count >= 3
                else { return nil }
            return newPassphrase
        }
        
        let validPrivateKey: Driver<String?> = fromView.privateKey.map {
            guard
                case let key = $0,
                key.count == 64
                else { return nil }
            return key
        }
        
        let keyRestorationKeystore: Driver<KeyRestoration?> = Driver.combineLatest(fromView.keystoreText, validEncryptionPassphrase.filterNil()) {
            try? KeyRestoration(keyStoreJSONString: $0, encryptedBy: $1)
        }
        
        let keyRestorationPrivateKey: Driver<KeyRestoration?> = Driver.combineLatest(validPrivateKey.filterNil(), validEncryptionPassphrase.filterNil()) {
            try? KeyRestoration(privateKeyHexString: $0, encryptBy: $1)
        }
        
        let keyRestoration = Driver.merge(keyRestorationKeystore, keyRestorationPrivateKey)
        
        
        let wallet = keyRestoration.filterNil().flatMapLatest {
            self.useCase.restoreWallet(from: $0)
                .asDriverOnErrorReturnEmpty()
        }
        
        bag <~ [
            fromView.restoreTrigger
                .withLatestFrom(wallet).do(onNext: { [weak s=stepper] in
                    s?.step(.didRestore(wallet: $0))
                })
                .drive()
        ]
        
        let isRestoreButtonEnabled = keyRestoration.map { $0 != nil }
        
        return Output(
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
        let isRestoreButtonEnabled: Driver<Bool>
    }
}
