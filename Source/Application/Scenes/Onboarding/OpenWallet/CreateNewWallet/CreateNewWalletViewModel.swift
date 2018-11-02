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

final class CreateNewWalletViewModel:
AbstractViewModel<
    CreateNewWalletViewModel.Step,
    CreateNewWalletViewModel.InputFromView,
    CreateNewWalletViewModel.Output
> {
    enum Step {
        case userInitiatedCreationOf(wallet: Wallet)
    }

    private let useCase: ChooseWalletUseCase

    init(useCase: ChooseWalletUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        let fromView = input.fromView

        let validEncryptionPassphrase: Driver<String?> = Driver.combineLatest(fromView.newEncryptionPassphrase, fromView.confirmedNewEncryptionPassphrase) {
            guard
                $0 == $1,
                case let newPassphrase = $0,
                newPassphrase.count >= 3
                else { return nil }
            return newPassphrase
        }

        let isCreateWalletButtonEnabled = Driver.combineLatest(validEncryptionPassphrase.map { $0 != nil }, input.fromView.understandsRisk) { $0 && $1 }

        fromView.createWalletTrigger.withLatestFrom(validEncryptionPassphrase.filterNil()) { $1 }
            .flatMapLatest {
                self.useCase.createNewWallet(encryptionPassphrase: $0)
                    .asDriverOnErrorReturnEmpty()
            }
            .do(onNext: { [unowned stepper] in stepper.step(.userInitiatedCreationOf(wallet: $0)) })
            .drive()
            .disposed(by: bag)


        return Output(
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
        let isCreateWalletButtonEnabled: Driver<Bool>
    }
}
