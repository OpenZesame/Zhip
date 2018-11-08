//
//  CreateNewWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FormValidatorSwift
import Zesame

// MARK: - CreateNewWalletNavigator
enum CreateNewWalletNavigator: TrackedUserAction {
     case userInitiatedCreationOfWallet(Wallet)
}

// MARK: - CreateNewWalletViewModel
final class CreateNewWalletViewModel:
AbstractViewModel<
    CreateNewWalletNavigator,
    CreateNewWalletViewModel.InputFromView,
    CreateNewWalletViewModel.Output
> {
    private let useCase: WalletUseCase

    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        let fromView = input.fromView

        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .new

        let validEncryptionPassphrase: Driver<String?> = Observable.combineLatest(
            fromView.newEncryptionPassphrase.asObservable(),
            fromView.confirmedNewEncryptionPassphrase.asObservable()
        ) {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $1, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }.asDriverOnErrorReturnEmpty()

        let isCreateWalletButtonEnabled = Driver.combineLatest(validEncryptionPassphrase.map { $0 != nil }, input.fromView.understandsRisk) { $0 && $1 }

        fromView.createWalletTrigger.withLatestFrom(validEncryptionPassphrase.filterNil()) { $1 }
            .flatMapLatest {
                self.useCase.createNewWallet(encryptionPassphrase: $0)
                    .asDriverOnErrorReturnEmpty()
            }
            .do(onNext: { [unowned stepper] in stepper.step(.userInitiatedCreationOfWallet($0)) })
            .drive()
            .disposed(by: bag)


        return Output(
            encryptionPassphrasePlaceholder: .just("Encryption passphrase (min \(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)) chars)"),
            isCreateWalletButtonEnabled: isCreateWalletButtonEnabled
        )
    }
}

extension CreateNewWalletViewModel {

    struct InputFromView {
        let newEncryptionPassphrase: Driver<String>
        let confirmedNewEncryptionPassphrase: Driver<String>
        
        let understandsRisk: Driver<Bool>
        let createWalletTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let isCreateWalletButtonEnabled: Driver<Bool>
    }
}
