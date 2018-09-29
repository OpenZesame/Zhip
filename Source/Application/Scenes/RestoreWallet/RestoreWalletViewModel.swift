//
//  RestoreWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxCocoa
import RxSwift
import Zesame

final class RestoreWalletViewModel {
    private let bag = DisposeBag()

    private weak var navigator: RestoreWalletNavigator?

    init(navigator: RestoreWalletNavigator) {
        self.navigator = navigator
    }
}

extension RestoreWalletViewModel: ViewModelType {

    struct Input {
        let privateKey: Driver<String>
        let restoreTrigger: Driver<Void>
    }

    struct Output {}

    func transform(input: Input) -> Output {

        let wallet = input.privateKey
            .map { Wallet(privateKeyHex: $0) }
            .filterNil()

        input.restoreTrigger
            .withLatestFrom(wallet).do(onNext: {
                self.navigator?.toMain(restoredWallet: $0)
            }).drive().disposed(by: bag)

        return Output()
    }
}
