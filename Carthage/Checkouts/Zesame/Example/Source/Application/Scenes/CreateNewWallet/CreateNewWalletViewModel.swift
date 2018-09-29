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
        let emailAddress: Driver<String?>
        let sendBackupTrigger: Driver<Void>
    }

    struct Output {
        let canSendBackup: Driver<Bool>
        let wallet: Driver<Wallet>
    }

    func transform(input: Input) -> Output {
        let emailValidator = EmailValidator()

        let isEmailValid = input.emailAddress.map { $0.validates(by: emailValidator) }.startWith(false)

        let wallet = service.createNewWallet()
        let keystore = wallet.flatMapLatest {
            return self.service.exportKeystore(from: $0, encryptWalletBy: "apa")
        }.asDriverOnErrorReturnEmpty()

        keystore.do(onNext: { print("Successfully created keystore: \($0.toJson())")}).drive().disposed(by: bag)

        return Output(
            canSendBackup: isEmailValid,
            wallet: wallet.asDriverOnErrorReturnEmpty()
        )
    }

}
