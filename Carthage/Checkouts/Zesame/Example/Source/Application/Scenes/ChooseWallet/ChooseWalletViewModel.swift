//
//  ChooseWalletViewModel.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChooseWalletViewModel {
    private let bag = DisposeBag()

    private weak var navigator: ChooseWalletNavigator?

    init(navigator: ChooseWalletNavigator) {
        self.navigator = navigator
    }
}

extension ChooseWalletViewModel: ViewModelType {

    struct Input {
        let createNewTrigger: Driver<Void>
        let restoreTrigger: Driver<Void>
    }

    struct Output {}

    func transform(input: Input) -> Output {

        input.createNewTrigger.do(onNext: {
            self.navigator?.toCreateNewWallet()
        }).drive().disposed(by: bag)

        input.restoreTrigger.do(onNext: {
            self.navigator?.toRestoreWallet()
        }).drive().disposed(by: bag)

        return Output()
    }
}
