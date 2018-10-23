//
//  CreateNewWalletViewModel.swift
//  ZesameiOSExample
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

    private let service: ZilliqaServiceReactive

    init(navigator: CreateNewWalletNavigator, service: ZilliqaServiceReactive) {
        self.navigator = navigator
        self.service = service
    }
}

extension CreateNewWalletViewModel: ViewModelType {

    struct Input {
        let encryptionPassphrase: Driver<String?>
        let confirmedEncryptionPassphrase: Driver<String?>
        let createWalletTrigger: Driver<Void>
    }

    struct Output {
        let isCreateWalletButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let validEncryptionPassphrase: Driver<String?> = Driver.combineLatest(input.encryptionPassphrase, input.confirmedEncryptionPassphrase) {
            guard
                $0 == $1,
                let newPassphrase = $0,
                newPassphrase.count >= 3
                else { return nil }
            return newPassphrase
        }

        let isCreateWalletButtonEnabled = validEncryptionPassphrase.map { $0 != nil }
        
        
        input.createWalletTrigger.withLatestFrom(validEncryptionPassphrase.filterNil()) { $1 } //.flatMapLatest { (passphrase: String?) -> Driver<Wallet?> in
            .flatMapLatest {
                self.service.createNewWallet(encryptionPassphrase: $0)
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
