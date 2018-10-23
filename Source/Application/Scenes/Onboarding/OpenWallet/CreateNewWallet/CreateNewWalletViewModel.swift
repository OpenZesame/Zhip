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

final class CreateNewWalletViewModel {

    private let bag = DisposeBag()

    private weak var navigator: CreateNewWalletNavigator?

    private let useCase: ChooseWalletUseCase

    init(navigator: CreateNewWalletNavigator, useCase: ChooseWalletUseCase) {

        self.navigator = navigator
        self.useCase = useCase

    }
}

extension CreateNewWalletViewModel: ViewModelType {

    struct Input: InputType {
        struct FromView {
            let newEncryptionPassphrase: Driver<String>
            let confirmedNewEncryptionPassphrase: Driver<String>
            let createWalletTrigger: Driver<Void>
        }
        let fromController: ControllerInput
        let fromView: FromView

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {
        let isCreateWalletButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        let fromView = input.fromView

        let validEncryptionPassphrase: Driver<String?> = Driver.combineLatest(fromView.newEncryptionPassphrase, fromView.confirmedNewEncryptionPassphrase) {
            guard
                $0 == $1,
                case let newPassphrase = $0,
                newPassphrase.count >= 3
                else { return nil }
            return newPassphrase
        }

        let isCreateWalletButtonEnabled = validEncryptionPassphrase.map { $0 != nil }


        fromView.createWalletTrigger.withLatestFrom(validEncryptionPassphrase.filterNil()) { $1 }
            .flatMapLatest {
                self.useCase.createNewWallet(encryptionPassphrase: $0)
                    .asDriverOnErrorReturnEmpty()
            }
            .do(onNext: { self.navigator?.toMain(wallet: $0) })
            .drive()
            .disposed(by: bag)


        return Output(
            isCreateWalletButtonEnabled: isCreateWalletButtonEnabled
        )
    }

}
