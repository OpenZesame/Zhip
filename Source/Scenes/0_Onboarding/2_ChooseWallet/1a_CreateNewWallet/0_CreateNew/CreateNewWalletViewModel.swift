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
import Zesame

private typealias € = L10n.Scene.CreateNewWallet

// MARK: - CreateNewWalletUserAction
enum CreateNewWalletUserAction: TrackedUserAction {
     case createWallet(Wallet)
}

// MARK: - CreateNewWalletViewModel
final class CreateNewWalletViewModel:
BaseViewModel<
    CreateNewWalletUserAction,
    CreateNewWalletViewModel.InputFromView,
    CreateNewWalletViewModel.Output
> {
    private let useCase: WalletUseCase

    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: Step) {
            stepper.step(userAction)
        }

        let fromView = input.fromView

        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .new

        let validEncryptionPassphrase: Driver<String?> = Observable.combineLatest(
            fromView.newEncryptionPassphrase.asObservable(),
            fromView.confirmedNewEncryptionPassphrase.asObservable()
        ) {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $1, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }.asDriverOnErrorReturnEmpty()

        let isCreateWalletButtonEnabled = Driver.combineLatest(validEncryptionPassphrase.map { $0 != nil }, input.fromView.understandsRisk) { $0 && $1 }

        let activityIndicator = ActivityIndicator()

        fromView.createWalletTrigger.withLatestFrom(validEncryptionPassphrase.filterNil()) { $1 }
            .flatMapLatest {
                self.useCase.createNewWallet(encryptionPassphrase: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorReturnEmpty()
            }
            .do(onNext: { userDid(.createWallet($0)) })
            .drive()
            .disposed(by: bag)

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        return Output(
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            isCreateWalletButtonEnabled: isCreateWalletButtonEnabled,
            isButtonLoading: activityIndicator.asDriver()
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
        let isButtonLoading: Driver<Bool>
    }
}
